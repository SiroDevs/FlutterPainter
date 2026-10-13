part of 'workspace_cubit.dart';

/// What the tab strip shows for one open project.
class TabInfo extends Equatable {
  const TabInfo({
    required this.id,
    required this.title,
    this.path,
    this.dirty = false,
  });

  final String id;
  final String title;
  final String? path;
  final bool dirty;

  TabInfo copyWith({
    String? id,
    String? title,
    Object? path = unset,
    bool? dirty,
  }) =>
      TabInfo(
        id: id ?? this.id,
        title: title ?? this.title,
        path: keep<String>(path, this.path),
        dirty: dirty ?? this.dirty,
      );

  @override
  List<Object?> get props => [id, title, path, dirty];
}

class WorkspaceState extends Equatable {
  const WorkspaceState({
    this.tabs = const <TabInfo>[],
    this.active = 0,
    this.autoSave = false,
  });

  final List<TabInfo> tabs;
  final int active;

  /// Write edits straight into the open file instead of only to a side copy.
  final bool autoSave;

  WorkspaceState copyWith({
    List<TabInfo>? tabs,
    int? active,
    bool? autoSave,
  }) =>
      WorkspaceState(
        tabs: tabs ?? this.tabs,
        active: active ?? this.active,
        autoSave: autoSave ?? this.autoSave,
      );

  @override
  List<Object?> get props => [tabs, active, autoSave];
}
