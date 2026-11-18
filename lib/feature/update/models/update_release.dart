/// Describes the matching binary published for one application release.
class UpdateRelease {
  const UpdateRelease({
    required this.version,
    required this.releaseUrl,
    required this.assetName,
    required this.assetUrl,
    required this.sha256,
  });

  final String version;
  final String releaseUrl;
  final String assetName;
  final String assetUrl;
  final String? sha256;
}
