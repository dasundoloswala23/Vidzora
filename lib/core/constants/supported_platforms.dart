import 'package:flutter/material.dart';

/// Describes one social platform Vidzora can fetch media from.
class SupportedPlatform {
  const SupportedPlatform({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color color;
}

/// Static registry of supported platforms and their brand colors.
class SupportedPlatforms {
  SupportedPlatforms._();

  static const Color tiktokBlack = Color(0xFF000000);
  static const Color tiktokPink = Color(0xFFFE2C55);
  static const Color instagramPink = Color(0xFFE1306C);
  static const Color instagramPurple = Color(0xFF833AB4);
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color linkedinBlue = Color(0xFF0A66C2);

  static const List<SupportedPlatform> all = [
    SupportedPlatform(
      id: 'tiktok',
      label: 'TikTok',
      icon: Icons.music_note_rounded,
      color: tiktokPink,
    ),
    SupportedPlatform(
      id: 'instagram',
      label: 'Instagram',
      icon: Icons.camera_alt_rounded,
      color: instagramPink,
    ),
    SupportedPlatform(
      id: 'facebook',
      label: 'Facebook',
      icon: Icons.facebook_rounded,
      color: facebookBlue,
    ),
  ];

  static SupportedPlatform byId(String id) {
    return all.firstWhere(
      (p) => p.id == id,
      orElse: () => const SupportedPlatform(
        id: 'unknown',
        label: 'Unknown',
        icon: Icons.link_rounded,
        color: Colors.grey,
      ),
    );
  }
}
