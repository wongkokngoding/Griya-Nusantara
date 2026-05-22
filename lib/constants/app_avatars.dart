import 'package:flutter/material.dart';
import 'package:griyanusantara/app_colors.dart';

/// Satu opsi avatar yang bisa dipilih pengguna.
class AppAvatarOption {
  const AppAvatarOption({
    required this.id,
    required this.label,
    required this.icon,
    required this.background,
    required this.iconColor,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color background;
  final Color iconColor;
}

/// Katalog avatar bawaan aplikasi.
class AppAvatars {
  AppAvatars._();

  static const String defaultId = 'penjelajah';

  static const List<AppAvatarOption> all = [
    AppAvatarOption(
      id: 'penjelajah',
      label: 'Penjelajah',
      icon: Icons.explore_rounded,
      background: Color(0xFFE8F0EB),
      iconColor: AppColors.primary,
    ),
    AppAvatarOption(
      id: 'pakar',
      label: 'Pakar Budaya',
      icon: Icons.menu_book_rounded,
      background: Color(0xFFEDF4F0),
      iconColor: Color(0xFF2D6A4F),
    ),
    AppAvatarOption(
      id: 'pengrajin',
      label: 'Pengrajin',
      icon: Icons.palette_rounded,
      background: Color(0xFFF5EDD6),
      iconColor: AppColors.accent,
    ),
    AppAvatarOption(
      id: 'penjaga',
      label: 'Penjaga Adat',
      icon: Icons.shield_rounded,
      background: Color(0xFFEDE6DC),
      iconColor: Color(0xFF6B4E2E),
    ),
    AppAvatarOption(
      id: 'pahlawan',
      label: 'Pahlawan',
      icon: Icons.emoji_events_rounded,
      background: Color(0xFFFFF4D6),
      iconColor: Color(0xFFB8962E),
    ),
    AppAvatarOption(
      id: 'alam',
      label: 'Penjaga Alam',
      icon: Icons.eco_rounded,
      background: Color(0xFFE2EFE6),
      iconColor: Color(0xFF40916C),
    ),
    AppAvatarOption(
      id: 'warisan',
      label: 'Warisan',
      icon: Icons.account_balance_rounded,
      background: Color(0xFFDCE8E2),
      iconColor: Color(0xFF1B4332),
    ),
    AppAvatarOption(
      id: 'legenda',
      label: 'Legenda',
      icon: Icons.auto_awesome_rounded,
      background: Color(0xFFF0E8D8),
      iconColor: Color(0xFF52796F),
    ),
  ];

  static AppAvatarOption byId(String? id) {
    if (id == null || id.isEmpty) {
      return all.first;
    }
    return all.firstWhere(
      (a) => a.id == id,
      orElse: () => all.first,
    );
  }
}

/// Widget avatar bulat untuk profil.
class AppAvatarWidget extends StatelessWidget {
  const AppAvatarWidget({
    super.key,
    required this.avatarId,
    this.radius = 52,
    this.fallbackInitial,
  });

  final String? avatarId;
  final double radius;
  final String? fallbackInitial;

  @override
  Widget build(BuildContext context) {
    final option = AppAvatars.byId(avatarId);
    return CircleAvatar(
      radius: radius,
      backgroundColor: option.background,
      child: Icon(
        option.icon,
        size: radius * 0.9,
        color: option.iconColor,
      ),
    );
  }
}
