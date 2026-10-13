// Dart imports:
import 'dart:convert';

// Project imports:
import '../../domain/models/draft.dart';
import 'drawing_mapper.dart';

String draftToJson(Draft d) => jsonEncode({
      'tabId': d.tabId,
      'path': d.path,
      'savedAt': d.savedAt.toIso8601String(),
      'drawing': drawingToMap(d.drawing),
    });

Draft draftFromJson(String text) {
  final j = jsonDecode(text) as Map<String, dynamic>;
  return Draft(
    tabId: j['tabId'] as String,
    path: j['path'] as String?,
    savedAt: DateTime.parse(j['savedAt'] as String),
    drawing: drawingFromMap(j['drawing'] as Map<String, dynamic>),
  );
}
