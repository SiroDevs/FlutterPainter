#!/usr/bin/env bash
# Usage: staple.sh <file.app|file.dmg>
# Staples the notarization ticket, retrying: the ticket download from Apple's CloudKit
# occasionally drops or lags right after notarization (error 68 / NSURLErrorDomain -1005).
set -euo pipefail

TARGET="$1"
ATTEMPTS=6

for i in $(seq 1 "$ATTEMPTS"); do
  if xcrun stapler staple "$TARGET"; then
    xcrun stapler validate "$TARGET"
    exit 0
  fi
  if [ "$i" -lt "$ATTEMPTS" ]; then
    WAIT=$((i * 20))
    echo "::warning::stapler failed (attempt $i/$ATTEMPTS); retrying in ${WAIT}s"
    sleep "$WAIT"
  fi
done

echo "::error::Could not staple $(basename "$TARGET") after $ATTEMPTS attempts (Apple ticket service unreachable). The notarization itself was accepted; re-run the failed job."
exit 1
