import 'package:flutter/material.dart';
import '../../../core/theme/app_theme_extensions.dart';
import '../../../core/widgets/section_label.dart';

/// A labeled white rounded card grouping related settings rows, with
/// thin dividers automatically inserted between [children].
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(text: label),
        Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
