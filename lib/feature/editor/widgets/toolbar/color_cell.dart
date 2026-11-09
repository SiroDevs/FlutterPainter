// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/constants/palette_constants.dart';
import '../../bloc/editor_bloc.dart';

/// A palette cell that applies fill or stroke color on click.
class ColorCell extends StatelessWidget {
  const ColorCell({super.key, required this.color, required this.size});

  final int color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    return Tooltip(
      message: hexOf(color),
      child: GestureDetector(
        onTap: () => bloc.add(ColorPicked(color)),
        onSecondaryTap: () => bloc.add(StrokeColorPicked(color)),
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
