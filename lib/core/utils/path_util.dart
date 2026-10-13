import '../../common/constants/app_constants.dart';

/// "C:\art\rider.flp" -> "rider".
String baseNameOf(String path) {
  final file = path.split(RegExp(r'[\\/]')).last;
  final dot = file.lastIndexOf('.');
  return dot > 0 ? file.substring(0, dot) : file;
}

bool isProjectFile(String path) {
  final p = path.toLowerCase();
  return p.endsWith('.${AppConstants.projectExtension}') || p.endsWith('.json');
}

bool isImageFile(String path) {
  final p = path.toLowerCase();
  return ['.png', '.jpg', '.jpeg', '.webp', '.bmp', '.gif'].any(p.endsWith);
}
