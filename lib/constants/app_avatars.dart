import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:griyanusantara/app_colors.dart';

/// Satu opsi avatar yang bisa dipilih pengguna.
class AppAvatarOption {
  const AppAvatarOption({
    required this.id,
    required this.label,
    required this.assetPath,
    required this.background,
    required this.iconColor,
  });

  final String id;
  final String label;
  final String assetPath;
  final Color background;
  final Color iconColor;
}

/// Katalog avatar bawaan aplikasi.
class AppAvatars {
  AppAvatars._();

  static const String defaultId = 'pria-1';

  static const List<AppAvatarOption> all = [
    AppAvatarOption(
      id: 'pria-1',
      label: 'Pria 1',
      assetPath: 'assets/images/pria-1.svg',
      background: Color(0xFFE8F0EB),
      iconColor: AppColors.primary,
    ),
    AppAvatarOption(
      id: 'pria-2',
      label: 'Pria 2',
      assetPath: 'assets/images/pria-2.svg',
      background: Color(0xFFEDF4F0),
      iconColor: Color(0xFF2D6A4F),
    ),
    AppAvatarOption(
      id: 'pria-3',
      label: 'Pria 3',
      assetPath: 'assets/images/pria-3.svg',
      background: Color(0xFFF5EDD6),
      iconColor: AppColors.accent,
    ),
    AppAvatarOption(
      id: 'wanita-1',
      label: 'Wanita 1',
      assetPath: 'assets/images/wanita-1.svg',
      background: Color(0xFFEDE6DC),
      iconColor: Color(0xFF6B4E2E),
    ),
    AppAvatarOption(
      id: 'wanita-2',
      label: 'Wanita 2',
      assetPath: 'assets/images/wanita-2.svg',
      background: Color(0xFFFFF4D6),
      iconColor: Color(0xFFB8962E),
    ),
    AppAvatarOption(
      id: 'wanita-3',
      label: 'Wanita 3',
      assetPath: 'assets/images/wanita-3.svg',
      background: Color(0xFFE2EFE6),
      iconColor: Color(0xFF40916C),
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
      child: ClipOval(
        child: SvgPicture.asset(
          option.assetPath,
          width: radius * 2.4,
          height: radius * 2.4,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(option.iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
