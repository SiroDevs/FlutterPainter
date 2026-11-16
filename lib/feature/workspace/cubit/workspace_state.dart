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
    this.persistFailed = false,
  });

  final List<TabInfo> tabs;
  final int active;

  /// Write edits straight into the open file instead of only to a side copy.
  final bool autoSave;

  /// True while some tab's work could not be written to disk (side copy or
  /// auto-save), so the user should save by hand.
  final bool persistFailed;

  WorkspaceState copyWith({
    List<TabInfo>? tabs,
    int? active,
    bool? autoSave,
    bool? persistFailed,
  }) =>
      WorkspaceState(
        tabs: tabs ?? this.tabs,
        active: active ?? this.active,
        autoSave: autoSave ?? this.autoSave,
        persistFailed: persistFailed ?? this.persistFailed,
      );

  @override
  List<Object?> get props => [tabs, active, autoSave, persistFailed];
}
