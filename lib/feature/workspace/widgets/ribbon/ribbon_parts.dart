// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../commands/app_command.dart';

/// A labelled cluster of buttons in the ribbon, with the name underneath and a
/// divider on its right, like "Clipboard" or "Font" in Word.
class RibbonGroup extends StatelessWidget {
  const RibbonGroup({super.key, required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 2),
        child: Column(children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ]),
      ),
      VerticalDivider(
        width: 1,
        indent: 8,
        endIndent: 8,
        color: scheme.outlineVariant,
      ),
    ]);
  }
}

/// A ribbon button for an [AppCommand]: large (icon above the name) or small
/// (icon beside the name, for stacking three high).
class RibbonButton extends StatelessWidget {
  const RibbonButton.large(this.command, {super.key, this.label})
      : large = true;

  const RibbonButton.small(this.command, {super.key, this.label})
      : large = false;

  final AppCommand command;
  final bool large;

  /// Overrides the command's label where the ribbon wants a shorter one.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = command.enabled;
    final on = command.checked ?? false;
    final fg = !enabled
        ? scheme.onSurface.withAlpha(97)
        : (on ? scheme.onPrimaryContainer : scheme.onSurface);
    final text = label ?? command.label;

    final Widget content = large
        ? SizedBox(
            width: 62,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(command.icon, size: 28, color: fg),
                const SizedBox(height: 4),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, height: 1.1, color: fg),
                ),
              ],
            ),
          )
        : Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(command.icon, size: 16, color: fg),
            const SizedBox(width: 6),
            Text(text, style: TextStyle(fontSize: 12, color: fg)),
          ]);

    return Tooltip(
      message: command.tip,
      waitDuration: const Duration(milliseconds: 600),
      child: Padding(
        padding: EdgeInsets.all(large ? 1 : 0),
        child: Material(
          color: on ? scheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: command.onPressed,
            child: Padding(
              padding: large
                  ? const EdgeInsets.symmetric(horizontal: 3, vertical: 4)
                  : const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

/// Up to three small controls stacked in one column.
class RibbonStack extends StatelessWidget {
  const RibbonStack({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
}

/// A line of text in the ribbon (for example the zoom level).
class RibbonLabel extends StatelessWidget {
  const RibbonLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(text, style: const TextStyle(fontSize: 12)),
      );
}

/// A slim labelled slider that fits three-high in a ribbon group. With a null
/// [onChanged] it is shown disabled.
class RibbonSlider extends StatelessWidget {
  const RibbonSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.onChanged,
    this.onChangeEnd,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final VoidCallback? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: 96,
          child: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            ),
            child: Slider(
              value: value.clamp(min, max).toDouble(),
              min: min,
              max: max,
              onChanged: onChanged,
              onChangeEnd: onChangeEnd == null ? null : (_) => onChangeEnd!(),
            ),
          ),
        ),
      ]),
    );
  }
}

/// A compact icon-only button for an [AppCommand] (used in the ribbon's tab row
/// and the minimal bar).
class CommandIconButton extends StatelessWidget {
  const CommandIconButton(this.command, {super.key});

  final AppCommand command;

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: command.tip,
        iconSize: 18,
        visualDensity: VisualDensity.compact,
        icon: Icon(command.icon),
        onPressed: command.onPressed,
      );
}
