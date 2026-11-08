import 'package:flutter/material.dart';

class SettingField extends StatelessWidget {
  const SettingField({required this.label, required this.child, this.help});

  final String label;
  final String? help;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.titleSmall),
          if (help != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 6),
              child: Text(
                help!,
                style: text.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
