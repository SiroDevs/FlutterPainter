// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../commands/workspace_commands.dart';
import 'tabs/arrange_tab.dart';
import 'tabs/file_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/image_tab.dart';
import 'tabs/insert_tab.dart';
import 'tabs/layer_tab.dart';
import 'tabs/view_tab.dart';

/// The ribbon's tabs, left to right.
enum RibbonTab {
  file,
  home,
  arrange,
  insert,
  layer,
  image,
  view;

  String localizedTitle(BuildContext context) => switch (this) {
    RibbonTab.file => context.l10n.ribbonFile,
    RibbonTab.home => context.l10n.ribbonHome,
    RibbonTab.arrange => context.l10n.ribbonArrangeTab,
    RibbonTab.insert => context.l10n.ribbonInsert,
    RibbonTab.layer => context.l10n.ribbonLayer,
    RibbonTab.image => context.l10n.ribbonImage,
    RibbonTab.view => context.l10n.ribbonView,
  };
}

/// The groups shown under [tab].
List<Widget> ribbonGroups(RibbonTab tab, WorkspaceCommands c) => switch (tab) {
  RibbonTab.file => fileTabGroups(c),
  RibbonTab.home => homeTabGroups(c),
  RibbonTab.insert => insertTabGroups(c),
  RibbonTab.layer => layerTabGroups(c),
  RibbonTab.image => imageTabGroups(c),
  RibbonTab.view => viewTabGroups(c),
  RibbonTab.arrange => arrangeTabGroups(c),
};
