// Flutter imports:
import 'package:flutter/material.dart';

/// A small colour chip that opens a picker when tapped.
class ColorSwatchButton extends StatelessWidget {
  const ColorSwatchButton({
    super.key,
    required this.color,
    required this.onTap,
  });

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 28,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.white54),
      ),
    ),
  );
}
