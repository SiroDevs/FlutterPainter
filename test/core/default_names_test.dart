// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/core/utils/default_names.dart';

void main() {
  group('appLocalizationsFor', () {
    test('returns the requested language', () {
      expect(appLocalizationsFor('en').untitledProject, 'Untitled');
      expect(appLocalizationsFor('fr').untitledProject, 'Sans titre');
      expect(appLocalizationsFor('sw').untitledProject, 'Bila jina');
    });

    test('falls back to English for unknown codes', () {
      expect(appLocalizationsFor('xx').untitledProject, 'Untitled');
      expect(appLocalizationsFor('').untitledProject, 'Untitled');
    });

    test('numbered names include the number', () {
      expect(appLocalizationsFor('en').defaultLayerName(3), contains('3'));
      expect(appLocalizationsFor('fr').defaultGroupName(2), contains('2'));
    });
  });

  group('isDefaultProjectName', () {
    test('recognises generated names in every language', () {
      for (final code in ['en', 'fr', 'sw']) {
        final l10n = appLocalizationsFor(code);
        expect(isDefaultProjectName(l10n.untitledProject), isTrue, reason: code);
        expect(
          isDefaultProjectName(l10n.untitledProjectNumbered(2)),
          isTrue,
          reason: code,
        );
      }
    });

    test('rejects names the user chose', () {
      expect(isDefaultProjectName('Rider'), isFalse);
      expect(isDefaultProjectName('Untitled design'), isFalse);
      expect(isDefaultProjectName('Untitled 2 copy'), isFalse);
      expect(isDefaultProjectName(''), isFalse);
    });
  });
}
