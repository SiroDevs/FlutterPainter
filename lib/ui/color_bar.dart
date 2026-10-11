// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../editor/style_ops.dart';
import '../model/palette.dart';

/// Paint-style colour strip: two overlapping swatches (fill in front, stroke
/// behind), a hex field, the classic palette, and the colours already used.
/// Left-click a colour paints the active swatch; right-click paints the stroke.
class ColorBar extends StatelessWidget {
  const ColorBar({super.key, required this.controller});

  final EditorController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final active = c.editFill ? c.fillColor : c.strokeColor;
        final activeOn = c.editFill ? c.fillOn : c.strokeOn;
        final hex = hexOf(active);
        return SizedBox(
          height: 104,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _swatches(context),
              const SizedBox(width: 12),
              SizedBox(
                width: 124,
                child: Column(children: [
                  TextFormField(
                    key: ValueKey('${c.editFill}-$hex'),
                    initialValue: hex,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      labelText: c.editFill ? 'Fill' : 'Stroke',
                    ),
                    onFieldSubmitted: (v) {
                      final parsed = parseHex(v);
                      if (parsed != null) c.setColor(parsed);
                    },
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      minimumSize: const Size(0, 28),
                    ),
                    onPressed: () => c.editFill
                        ? c.setFillOn(!activeOn)
                        : c.setStrokeOn(!activeOn),
                    icon: Icon(activeOn ? Icons.block : Icons.check, size: 16),
                    label: Text(activeOn ? 'None' : 'Use'),
                  ),
                ]),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 10 * 26.0,
                child: Wrap(spacing: 2, runSpacing: 2, children: [
                  for (final v in kPalette) _cell(v, 24),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(spacing: 2, runSpacing: 2, children: [
                    for (final v in c.drawing.usedColors()) _cell(v, 18),
                  ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _swatches(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    Widget box(bool isFill, int color, bool on) => Tooltip(
          message: isFill ? 'Fill colour' : 'Stroke colour',
          child: GestureDetector(
            onTap: () => controller.setEditFill(isFill),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: on ? Color(color) : const Color(0xFF2B2E34),
                border: Border.all(
                  color: controller.editFill == isFill ? accent : Colors.white38,
                  width: controller.editFill == isFill ? 3 : 1,
                ),
              ),
              child: on ? null : const Icon(Icons.block, size: 18),
            ),
          ),
        );
    return SizedBox(
      width: 64,
      height: 60,
      child: Stack(children: [
        Positioned(left: 22, top: 20, child: box(false, controller.strokeColor, controller.strokeOn)),
        Positioned(left: 0, top: 0, child: box(true, controller.fillColor, controller.fillOn)),
      ]),
    );
  }

  Widget _cell(int v, double size) => Tooltip(
        message: hexOf(v),
        child: GestureDetector(
          onTap: () => controller.setColor(v),
          onSecondaryTap: () => controller.setStrokeColor(v),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Color(v),
              border: Border.all(color: const Color(0x66808080)),
            ),
          ),
        ),
      );
}
