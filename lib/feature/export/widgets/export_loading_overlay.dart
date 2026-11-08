// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'vscode_colors.dart';

/// Shows a progress overlay when export work lasts beyond a short delay.
class ExportLoadingOverlay extends StatefulWidget {
  const ExportLoadingOverlay({
    super.key,
    required this.active,
    required this.label,
    required this.colors,
  });

  final bool active;
  final String label;
  final VsCodeColors colors;

  @override
  State<ExportLoadingOverlay> createState() => _ExportLoadingOverlayState();
}

class _ExportLoadingOverlayState extends State<ExportLoadingOverlay> {
  Timer? _timer;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void didUpdateWidget(ExportLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active == widget.active) return;
    _timer?.cancel();
    if (widget.active) {
      _schedule();
    } else if (_visible) {
      setState(() => _visible = false);
    }
  }

  /// Waits briefly before showing progress for short exports.
  void _schedule() {
    if (!widget.active) return;
    _timer = Timer(const Duration(milliseconds: 450), () {
      if (mounted && widget.active) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    return Positioned.fill(
      child: AbsorbPointer(
        child: ColoredBox(
          color: widget.colors.editorBg.withValues(alpha: 0.88),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: widget.colors.titleBar,
                border: Border.all(color: widget.colors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: widget.colors.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: TextStyle(color: widget.colors.titleText),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
