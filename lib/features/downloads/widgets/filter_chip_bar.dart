import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/enums/media_type.dart';

/// The "All / Videos / Audio" filter chip row on the Downloads screen.
class FilterChipBar extends StatelessWidget {
  const FilterChipBar({super.key, required this.selected, required this.onChanged});

  final MediaType? selected;
  final ValueChanged<MediaType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(label: 'All', value: null),
          const SizedBox(width: 8),
          _chip(label: 'Videos', value: MediaType.video),
          const SizedBox(width: 8),
          _chip(label: 'Audio', value: MediaType.audio),
          const SizedBox(width: 8),
          _chip(label: 'Images', value: MediaType.image),
        ],
      ),
    );
  }

  Widget _chip({required String label, required MediaType? value}) {
    final isActive = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primaryPurple : AppColors.dividerGrey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
