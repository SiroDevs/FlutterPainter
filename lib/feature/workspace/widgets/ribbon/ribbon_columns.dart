// Flutter imports:
import 'package:flutter/widgets.dart';

/// Lays ribbon controls into columns with up to two controls each.
class RibbonColumns extends StatelessWidget {
  const RibbonColumns({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var columnStart = 0;
              columnStart < children.length;
              columnStart += 2)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children.skip(columnStart).take(2).toList(),
              ),
            ),
        ],
      );
}
