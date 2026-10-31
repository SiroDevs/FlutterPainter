// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../commands/workspace_commands.dart';
import 'tabs/file_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/image_tab.dart';
import 'tabs/insert_tab.dart';
import 'tabs/layer_tab.dart';
import 'tabs/view_tab.dart';

/// The ribbon's tabs, left to right.
enum RibbonTab {
  file('File'),
  home('Home'),
  insert('Insert'),
  layer('Layer'),
  image('Image'),
  view('View');

  const RibbonTab(this.title);

  final String title;
}

/// The groups shown under [tab].
List<Widget> ribbonGroups(RibbonTab tab, WorkspaceCommands c) => switch (tab) {
  RibbonTab.file => fileTabGroups(c),
  RibbonTab.home => homeTabGroups(c),
  RibbonTab.insert => insertTabGroups(c),
  RibbonTab.layer => layerTabGroups(c),
  RibbonTab.image => imageTabGroups(c),
  RibbonTab.view => viewTabGroups(c),
};
