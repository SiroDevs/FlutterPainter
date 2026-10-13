part of 'workspace_cubit.dart';

/// What the tab strip shows for one open project.
@freezed
abstract class TabInfo with _$TabInfo {
  const factory TabInfo({
    required String id,
    required String title,
    String? path,
    @Default(false) bool dirty,
  }) = _TabInfo;
}

@freezed
abstract class WorkspaceState with _$WorkspaceState {
  const factory WorkspaceState({
    @Default(<TabInfo>[]) List<TabInfo> tabs,
    @Default(0) int active,

    /// Write edits straight into the open file instead of only to a side copy.
    @Default(false) bool autoSave,
  }) = _WorkspaceState;
}
