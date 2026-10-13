// Dart imports:
import 'dart:developer' as logging show log;
import 'dart:io';

bool isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

void logger(String message) => logging.log(message);

/// A short unique id for a tab. Also names the tab's side copy on disk.
String newTabId() => '${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}-'
    '${_counter++}';

int _counter = 0;
