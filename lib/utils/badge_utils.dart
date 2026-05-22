import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:griyanusantara/app_colors.dart';

/// Variasi warna turunan palet [AppColors] untuk badge.
class _BadgePalette {
  static const Color forestMid = Color(0xFF2D6A4F);
  static const Color greenLight = Color(0xFF40916C);
  static const Color goldDark = Color(0xFFB8962E);
  static const Color goldSoft = Color(0xFFE8D5A3);
  static const Color sage = Color(0xFF52796F);
  static const Color bronze = Color(0xFF6B4E2E);
}

/// Gaya warna per badge.
class BadgeStyle {
  const BadgeStyle({
    required this.foreground,
    required this.background,
    required this.border,
  });

  final Color foreground;
  final Color background;
  final Color border;
}

/// Utilitas ikon dan tampilan untuk badge gamifikasi.
class BadgeUtils {
  BadgeUtils._();

  static IconData iconFor(String badge) {
    if (badge == 'First Quiz') {
      return Icons.flag_circle_outlined;
    }
    if (badge == 'Perfect Score') {
      return Icons.stars_rounded;
    }
    if (badge == 'Cultural Hero') {
      return Icons.emoji_events_rounded;
    }
    if (badge.startsWith('Master ')) {
      return Icons.workspace_premium_rounded;
    }
    if (badge.startsWith('Explorer ')) {
      return Icons.explore_rounded;
    }
    if (badge.startsWith('Level ') && badge.endsWith(' Achieved')) {
      return Icons.trending_up_rounded;
    }
    return Icons.military_tech_rounded;
  }

  /// Penjelasan cara meraih badge, ditampilkan di dialog profil.
  static String descriptionFor(String badge) {
    if (badge == 'First Quiz') {
      return 'Diraih saat Anda menyelesaikan kuis pertama di Griya Nusantara.';
    }
    if (badge == 'Perfect Score') {
      return 'Diraih dengan mendapat skor 100% dalam satu sesi kuis.';
    }
    if (badge == 'Cultural Hero') {
      return 'Diraih dengan skor minimal 70% (belum sempurna) dalam satu sesi kuis.';
    }
    if (badge.startsWith('Master ')) {
      final region = badge.substring('Master '.length);
      return 'Diraih dengan skor 100% pada kuis wilayah $region.';
    }
    if (badge.startsWith('Explorer ')) {
      final region = badge.substring('Explorer '.length);
      return 'Diraih dengan skor minimal 40% pada kuis wilayah $region.';
    }
    if (badge.startsWith('Level ') && badge.endsWith(' Achieved')) {
      final levelStr = badge.substring('Level '.length, badge.length - ' Achieved'.length);
      return 'Diraih saat total XP Anda mencapai level $levelStr.';
    }
    return 'Badge penghargaan dari perjalanan belajar Anda di Griya Nusantara.';
  }

  static Future<void> showInfoDialog(
    BuildContext context,
    String badge, {
    List<Widget>? actions,
  }) {
    final style = styleFor(badge);
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: style.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: style.border),
                ),
                child: Icon(iconFor(badge), color: style.foreground, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  badge,
                  style: GoogleFonts.lora(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            descriptionFor(badge),
            style: GoogleFonts.manrope(
              fontSize: 14,
              height: 1.5,
              color: AppColors.greyText,
            ),
          ),
          actions: actions ??
              [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Tutup',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
        );
      },
    );
  }

  static BadgeStyle styleFor(String badge) {
    if (badge == 'First Quiz') {
      return BadgeStyle(
        foreground: AppColors.primary,
        background: AppColors.primary.withValues(alpha: 0.12),
        border: AppColors.primary.withValues(alpha: 0.28),
      );
    }
    if (badge == 'Perfect Score') {
      return BadgeStyle(
        foreground: AppColors.accent,
        background: AppColors.accent.withValues(alpha: 0.18),
        border: AppColors.accent.withValues(alpha: 0.35),
      );
    }
    if (badge == 'Cultural Hero') {
      return BadgeStyle(
        foreground: _BadgePalette.goldDark,
        background: _BadgePalette.goldSoft.withValues(alpha: 0.45),
        border: _BadgePalette.goldDark.withValues(alpha: 0.35),
      );
    }
    if (badge.startsWith('Master ')) {
      return BadgeStyle(
        foreground: _BadgePalette.bronze,
        background: AppColors.accent.withValues(alpha: 0.14),
        border: _BadgePalette.bronze.withValues(alpha: 0.3),
      );
    }
    if (badge.startsWith('Explorer ')) {
      return BadgeStyle(
        foreground: _BadgePalette.forestMid,
        background: _BadgePalette.greenLight.withValues(alpha: 0.15),
        border: _BadgePalette.forestMid.withValues(alpha: 0.28),
      );
    }
    if (badge.startsWith('Level ') && badge.endsWith(' Achieved')) {
      return BadgeStyle(
        foreground: _BadgePalette.sage,
        background: AppColors.border.withValues(alpha: 0.6),
        border: _BadgePalette.sage.withValues(alpha: 0.35),
      );
    }
    return BadgeStyle(
      foreground: AppColors.greyText,
      background: AppColors.border.withValues(alpha: 0.5),
      border: AppColors.greyText.withValues(alpha: 0.25),
    );
  }

  static Widget buildBadgeChip(
    String badge, {
    bool isFeatured = false,
    VoidCallback? onTap,
  }) {
    final style = styleFor(badge);
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isFeatured ? AppColors.primary : style.border,
          width: isFeatured ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconFor(badge), size: 20, color: style.foreground),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: style.foreground,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isFeatured) ...[
            const SizedBox(width: 6),
            Icon(Icons.push_pin_rounded, size: 16, color: style.foreground),
          ],
        ],
      ),
    );

    if (onTap == null) return chip;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: chip,
    );
  }

}
