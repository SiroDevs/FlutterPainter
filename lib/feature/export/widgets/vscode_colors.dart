// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../domain/services/dart_tokenizer.dart';

/// The colours of the code editor, taken from VS Code's "Dark+" and "Light+"
/// themes so it feels like the editor people already know.
class VsCodeColors {
  const VsCodeColors({
    required this.titleBar,
    required this.titleText,
    required this.activityBar,
    required this.activityIcon,
    required this.activityIconActive,
    required this.sideBar,
    required this.sideBarText,
    required this.sideBarHeader,
    required this.hover,
    required this.selection,
    required this.editorBg,
    required this.editorText,
    required this.lineNumber,
    required this.tabBar,
    required this.tabInactive,
    required this.tabInactiveText,
    required this.tabActiveText,
    required this.accent,
    required this.statusBar,
    required this.statusText,
    required this.border,
    required this.editorSelection,
    required this.comment,
    required this.string,
    required this.keyword,
    required this.number,
    required this.type,
    required this.annotation,
    required this.function,
  });

  factory VsCodeColors.of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  final Color titleBar;
  final Color titleText;
  final Color activityBar;
  final Color activityIcon;
  final Color activityIconActive;
  final Color sideBar;
  final Color sideBarText;
  final Color sideBarHeader;
  final Color hover;
  final Color selection;
  final Color editorBg;
  final Color editorText;
  final Color lineNumber;
  final Color tabBar;
  final Color tabInactive;
  final Color tabInactiveText;
  final Color tabActiveText;
  final Color accent;
  final Color statusBar;
  final Color statusText;
  final Color border;
  final Color editorSelection;

  final Color comment;
  final Color string;
  final Color keyword;
  final Color number;
  final Color type;
  final Color annotation;
  final Color function;

  static const dark = VsCodeColors(
    titleBar: Color(0xFF3C3C3C),
    titleText: Color(0xFFCCCCCC),
    activityBar: Color(0xFF333333),
    activityIcon: Color(0xFF858585),
    activityIconActive: Color(0xFFFFFFFF),
    sideBar: Color(0xFF252526),
    sideBarText: Color(0xFFCCCCCC),
    sideBarHeader: Color(0xFFBBBBBB),
    hover: Color(0xFF2A2D2E),
    selection: Color(0xFF37373D),
    editorBg: Color(0xFF1E1E1E),
    editorText: Color(0xFFD4D4D4),
    lineNumber: Color(0xFF858585),
    tabBar: Color(0xFF252526),
    tabInactive: Color(0xFF2D2D2D),
    tabInactiveText: Color(0xFF969696),
    tabActiveText: Color(0xFFFFFFFF),
    accent: Color(0xFF007ACC),
    statusBar: Color(0xFF007ACC),
    statusText: Color(0xFFFFFFFF),
    border: Color(0xFF3C3C3C),
    editorSelection: Color(0xFF264F78),
    comment: Color(0xFF6A9955),
    string: Color(0xFFCE9178),
    keyword: Color(0xFF569CD6),
    number: Color(0xFFB5CEA8),
    type: Color(0xFF4EC9B0),
    annotation: Color(0xFFDCDCAA),
    function: Color(0xFFDCDCAA),
  );

  static const light = VsCodeColors(
    titleBar: Color(0xFFDDDDDD),
    titleText: Color(0xFF333333),
    activityBar: Color(0xFF2C2C2C),
    activityIcon: Color(0x99FFFFFF),
    activityIconActive: Color(0xFFFFFFFF),
    sideBar: Color(0xFFF3F3F3),
    sideBarText: Color(0xFF616161),
    sideBarHeader: Color(0xFF6F6F6F),
    hover: Color(0xFFE8E8E8),
    selection: Color(0xFFE4E6F1),
    editorBg: Color(0xFFFFFFFF),
    editorText: Color(0xFF000000),
    lineNumber: Color(0xFF237893),
    tabBar: Color(0xFFF3F3F3),
    tabInactive: Color(0xFFECECEC),
    tabInactiveText: Color(0xFF8E8E8E),
    tabActiveText: Color(0xFF333333),
    accent: Color(0xFF007ACC),
    statusBar: Color(0xFF007ACC),
    statusText: Color(0xFFFFFFFF),
    border: Color(0xFFCECECE),
    editorSelection: Color(0xFFADD6FF),
    comment: Color(0xFF008000),
    string: Color(0xFFA31515),
    keyword: Color(0xFF0000FF),
    number: Color(0xFF098658),
    type: Color(0xFF267F99),
    annotation: Color(0xFF795E26),
    function: Color(0xFF795E26),
  );

  /// The colour for a syntax token.
  Color forToken(TokenKind kind) => switch (kind) {
        TokenKind.comment => comment,
        TokenKind.string => string,
        TokenKind.keyword => keyword,
        TokenKind.number => number,
        TokenKind.type => type,
        TokenKind.annotation => annotation,
        TokenKind.function => function,
      };

  /// Fonts that exist on each desktop platform; the first one found is used.
  static const String fontFamily = 'Consolas';
  static const List<String> fontFallback = [
    'Menlo',
    'Monaco',
    'DejaVu Sans Mono',
    'Liberation Mono',
    'Courier New',
    'monospace',
  ];
}
