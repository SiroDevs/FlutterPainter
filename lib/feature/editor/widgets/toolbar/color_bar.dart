// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/constants/palette_constants.dart';
import '../../bloc/editor_bloc.dart';
import '../../models/style_settings.dart';

/// Paint-style colour strip: two overlapping swatches (fill in front, stroke
/// behind), a hex field, the classic palette, and the colours already used.
/// Left-click a colour paints the active swatch; right-click paints the stroke.
class ColorBar extends StatelessWidget {
  const ColorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (a, b) =>
          a.style != b.style || !identical(a.history, b.history),
      builder: (context, state) {
        final st = state.style;
        final active = st.editFill ? st.fillColor : st.strokeColor;
        final activeOn = st.editFill ? st.fillOn : st.strokeOn;
        final hex = hexOf(active);
        final bloc = context.read<EditorBloc>();
        return SizedBox(
          height: 104,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Swatches(style: st),
              const SizedBox(width: 12),
              SizedBox(
                width: 124,
                child: Column(children: [
                  TextFormField(
                    key: ValueKey('${st.editFill}-$hex'),
                    initialValue: hex,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      labelText: st.editFill ? 'Fill' : 'Stroke',
                    ),
                    onFieldSubmitted: (v) {
                      final parsed = parseHex(v);
                      if (parsed != null) bloc.add(EditorEvent.colorPicked(parsed));
                    },
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      minimumSize: const Size(0, 28),
                    ),
                    onPressed: () => bloc.add(
                      st.editFill
                          ? EditorEvent.fillToggled(!activeOn)
                          : EditorEvent.strokeToggled(!activeOn),
                    ),
                    icon: Icon(activeOn ? Icons.block : Icons.check, size: 16),
                    label: Text(activeOn ? 'None' : 'Use'),
                  ),
                ]),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 10 * 26.0,
                child: Wrap(spacing: 2, runSpacing: 2, children: [
                  for (final v in kPalette) _Cell(color: v, size: 24),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(spacing: 2, runSpacing: 2, children: [
                    for (final v in state.drawing.usedColors) _Cell(color: v, size: 18),
                  ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

class _Swatches extends StatelessWidget {
  const _Swatches({required this.style});

  final StyleSettings style;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final bloc = context.read<EditorBloc>();

    Widget box(bool isFill, int color, bool on) => Tooltip(
          message: isFill ? 'Fill colour' : 'Stroke colour',
          child: GestureDetector(
            onTap: () => bloc.add(EditorEvent.styleTargetChanged(isFill)),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: on ? Color(color) : const Color(0xFF2B2E34),
                border: Border.all(
                  color: style.editFill == isFill ? accent : Colors.white38,
                  width: style.editFill == isFill ? 3 : 1,
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
        Positioned(left: 22, top: 20, child: box(false, style.strokeColor, style.strokeOn)),
        Positioned(left: 0, top: 0, child: box(true, style.fillColor, style.fillOn)),
      ]),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.color, required this.size});

  final int color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    return Tooltip(
      message: hexOf(color),
      child: GestureDetector(
        onTap: () => bloc.add(EditorEvent.colorPicked(color)),
        onSecondaryTap: () => bloc.add(EditorEvent.strokeColorPicked(color)),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Color(color),
            border: Border.all(color: const Color(0x66808080)),
          ),
        ),
      ),
    );
  }
}
