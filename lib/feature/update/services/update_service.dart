// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import '../models/update_release.dart';
import 'update_asset_selector.dart';
import 'update_notification_service.dart';

/// Checks GitHub releases and downloads verified installers.
class UpdateService {
  static final Uri _latestReleaseUri = Uri.https(
    'api.github.com',
    '/repos/SiroDevs/FlutterPainter/releases/latest',
  );

  final HttpClient _http = HttpClient()..userAgent = 'FlutterPainter';
  final UpdateNotificationService notifications = UpdateNotificationService();

  /// Closes the release connection when the application exits.
  void dispose() => _http.close(force: true);

  /// Prepares operating-system notification support.
  Future<void> initialize(String openReleaseAction) =>
      notifications.initialize(openReleaseAction);

  /// Returns a newer release when this system has a published installer.
  Future<UpdateRelease?> checkForUpdate() async {
    final release = await _getJson(_latestReleaseUri);
    final releaseVersion = _releaseVersion(release['tag_name'] as String?);
    if (releaseVersion == null || !await _isNewer(releaseVersion)) return null;

    final assets = (release['assets'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final assetName = await UpdateAssetSelector.select(releaseVersion);
    if (assetName == null) return null;
    final asset = _findAsset(assets, assetName);
    if (asset == null) return null;
    final sha256 = _sha256FromDigest(asset['digest']);
    final assetUrl = Uri.tryParse(
      asset['browser_download_url'] as String? ?? '',
    );
    if (assetUrl?.scheme != 'https' || assetUrl?.host != 'github.com') {
      return null;
    }

    return UpdateRelease(
      version: releaseVersion,
      releaseUrl:
          release['html_url'] as String? ??
          'https://github.com/SiroDevs/FlutterPainter/releases',
      assetName: assetName,
      assetUrl: assetUrl!.toString(),
      sha256: sha256,
    );
  }

  /// Downloads a release asset into the app's support directory.
  Future<File> download(UpdateRelease release) async {
    final directory = await getApplicationSupportDirectory();
    final updatesDirectory = Directory(
      '${directory.path}${Platform.pathSeparator}updates',
    );
    await updatesDirectory.create(recursive: true);
    final file = File(
      '${updatesDirectory.path}${Platform.pathSeparator}${release.assetName}',
    );
    final expectedHash = release.sha256;
    if (expectedHash == null ||
        !RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(expectedHash)) {
      throw const FormatException('Release checksum is invalid.');
    }
    final normalizedHash = expectedHash.toLowerCase();
    if (await file.exists() && await _matchesHash(file, normalizedHash)) {
      return file;
    }

    final request = await _http.getUrl(Uri.parse(release.assetUrl));
    final response = await request.close().timeout(const Duration(minutes: 5));
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('Release asset returned ${response.statusCode}.');
    }
    await response.pipe(file.openWrite());
    if (!await _matchesHash(file, normalizedHash)) {
      await file.delete();
      throw const FormatException('Downloaded release checksum did not match.');
    }
    return file;
  }

  /// Shows an update notification with a link to its GitHub release.
  Future<void> showNotification(String title, String body, String url) =>
      notifications.show(title, body, url);

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final request = await _http.getUrl(uri);
    request.headers.set(
      HttpHeaders.acceptHeader,
      'application/vnd.github+json',
    );
    final response = await request.close().timeout(const Duration(seconds: 20));
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('GitHub returned ${response.statusCode}.');
    }
    return jsonDecode(await response.transform(utf8.decoder).join())
        as Map<String, dynamic>;
  }

  Future<bool> _matchesHash(File file, String expected) async {
    final actual = await sha256.bind(file.openRead()).first;
    return actual.toString() == expected;
  }

  /// Extracts a valid SHA-256 digest from GitHub asset metadata.
  String? _sha256FromDigest(Object? digest) {
    if (digest is! String) return null;
    final match = RegExp(r'^sha256:([a-fA-F0-9]{64})$').firstMatch(digest);
    return match?.group(1)?.toLowerCase();
  }

  Map<String, dynamic>? _findAsset(
    List<Map<String, dynamic>> assets,
    String name,
  ) {
    for (final asset in assets) {
      if (asset['name'] == name) return asset;
    }
    return null;
  }

  /// Extracts the semantic app version from a canonical or legacy release tag.
  String? _releaseVersion(String? tag) {
    if (tag == null) return null;
    final match = RegExp(r'^v?(\d+\.\d+\.\d+)(?:[.+]\d+)?$').firstMatch(tag);
    return match?.group(1);
  }

  /// Compares app versions without treating build metadata as a new release.
  Future<bool> _isNewer(String releaseVersion) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final installed = packageInfo.version.split('+').first;
    final installedParts = installed.split('.').map(int.tryParse).toList();
    final releaseParts = releaseVersion.split('.').map(int.tryParse).toList();
    if (installedParts.length != 3 ||
        releaseParts.length != 3 ||
        installedParts.contains(null) ||
        releaseParts.contains(null)) {
      return false;
    }
    for (var index = 0; index < 3; index++) {
      final comparison = releaseParts[index]!.compareTo(installedParts[index]!);
      if (comparison != 0) return comparison > 0;
    }
    return false;
  }
}
