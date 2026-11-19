// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A small number box. Typing a value and leaving the box (or pressing enter)
/// sends it to [onSubmitted]; text that is not a number is put back.
class SliderValueField extends StatefulWidget {
  const SliderValueField({
    super.key,
    required this.value,
    required this.decimals,
    required this.onSubmitted,
    this.unit = '',
    this.compact = false,
  });

  final double value;
  final int decimals;
  final String unit;
  final bool compact;
  final ValueChanged<double> onSubmitted;

  @override
  State<SliderValueField> createState() => _SliderValueFieldState();
}

class _SliderValueFieldState extends State<SliderValueField> {
  static final RegExp _allowed = RegExp(r'[0-9.,\-]');

  late final TextEditingController _controller = TextEditingController(
    text: _shown,
  );
  final FocusNode _focus = FocusNode();
  bool _edited = false;

  String get _shown => widget.value.toStringAsFixed(widget.decimals);

  @override
  void initState() {
    super.initState();
    _focus.addListener(_focusChanged);
  }

  @override
  void didUpdateWidget(SliderValueField old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus && _controller.text != _shown) {
      _controller.text = _shown;
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _focusChanged() {
    if (_focus.hasFocus) {
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    } else {
      _submit();
    }
  }

  void _submit() {
    if (!_edited) return;
    _edited = false;
    final typed = double.tryParse(_controller.text.trim().replaceAll(',', '.'));
    if (typed != null) widget.onSubmitted(typed);
    // The parent may clamp or snap the value, so show what it kept.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_focus.hasFocus) _controller.text = _shown;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.compact ? 12.0 : null;
    return SizedBox(
      width: widget.compact ? 64 : 76,
      child: TextField(
        controller: _controller,
        focusNode: _focus,
        textAlign: TextAlign.end,
        style: TextStyle(fontSize: size),
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        inputFormatters: [FilteringTextInputFormatter.allow(_allowed)],
        decoration: InputDecoration(
          isDense: true,
          suffixText: widget.unit.isEmpty ? null : widget.unit,
          suffixStyle: TextStyle(fontSize: size),
          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          border: const UnderlineInputBorder(),
        ),
        onChanged: (_) => _edited = true,
        onSubmitted: (_) => _submit(),
      ),
    );
  }
}
