import 'package:flutter/material.dart';
import '../../../core/constants/supported_platforms.dart';
import '../../../core/widgets/platform_chip.dart';

/// A horizontal row of platform chips for the supported platforms.
class SupportedPlatformsRow extends StatelessWidget {
  const SupportedPlatformsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final platform in SupportedPlatforms.all) ...[
            PlatformChip(platform: platform),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
