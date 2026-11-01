// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../constants/palette_constants.dart';

// A text field for a colour code such as #C9222B or #80C9222B. It follows the
// colour it is given and reports a new one once the text is a valid code.
class HexCodeField extends StatefulWidget {
  const HexCodeField({
    super.key,
    required this.argb,
    required this.label,
    required this.onChanged,
  });

  final int argb;
  final String label;
  final ValueChanged<int> onChanged;

  @override
  State<HexCodeField> createState() => _HexCodeFieldState();
}

class _HexCodeFieldState extends State<HexCodeField> {
  late final TextEditingController _controller =
      TextEditingController(text: hexOf(widget.argb));

  @override
  void didUpdateWidget(HexCodeField old) {
    super.didUpdateWidget(old);
    final typed = parseHex(_controller.text);
    if (widget.argb != typed) _controller.text = hexOf(widget.argb);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
        labelText: widget.label,
      ),
      onChanged: (text) {
        final parsed = parseHex(text);
        if (parsed != null) widget.onChanged(parsed);
      },
    );
  }
}
