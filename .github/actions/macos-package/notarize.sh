#!/usr/bin/env bash
# Usage: notarize.sh <file.zip|file.dmg>
# Needs APPLE_ID, APPLE_APP_PASSWORD, APPLE_TEAM_ID in the environment.
set -euo pipefail

FILE="$1"
RESULT="$(mktemp)"

set +e
xcrun notarytool submit "$FILE" \
  --apple-id "$APPLE_ID" \
  --password "$APPLE_APP_PASSWORD" \
  --team-id "$APPLE_TEAM_ID" \
  --wait --timeout 30m \
  --output-format json > "$RESULT"
set -e

cat "$RESULT"
STATUS="$(jq -r '.status // "Unknown"' "$RESULT")"
ID="$(jq -r '.id // empty' "$RESULT")"

if [ "$STATUS" != "Accepted" ]; then
  if [ -n "$ID" ]; then
    echo "---- Apple notarization log ----"
    xcrun notarytool log "$ID" \
      --apple-id "$APPLE_ID" \
      --password "$APPLE_APP_PASSWORD" \
      --team-id "$APPLE_TEAM_ID" || true
  fi
  echo "::error::Notarization of $(basename "$FILE") ended with status: $STATUS"
  exit 1
fi
