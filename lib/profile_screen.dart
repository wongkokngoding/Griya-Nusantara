import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'constants/app_avatars.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'utils/badge_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSavingAvatar = false;
  bool _isSavingBadge = false;

  Future<void> _saveAvatar(User user, String avatarId) async {
    if (_isSavingAvatar) return;

    setState(() => _isSavingAvatar = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {'avatarId': avatarId},
        SetOptions(merge: true),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avatar berhasil diperbarui.'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan avatar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingAvatar = false);
      }
    }
  }

  Widget _buildFeaturedBadgeRow({
    required String badge,
    VoidCallback? onTap,
  }) {
    final style = BadgeUtils.styleFor(badge);
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(BadgeUtils.iconFor(badge), size: 20, color: style.foreground),
          const SizedBox(width: 8),
          Text(
            badge,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: style.foreground,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            onTap != null
                ? Icons.info_outline_rounded
                : Icons.push_pin_rounded,
            size: 16,
            color: style.foreground.withValues(alpha: 0.8),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: content,
    );
  }

  Widget _buildSelectBadgeButton({
    required VoidCallback? onPressed,
    String label = 'Pilih Badge',
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.military_tech_outlined, size: 20),
      label: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildProfileAvatar({
    required String avatarId,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isSavingAvatar ? null : onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppAvatarWidget(avatarId: avatarId, radius: 52),
          if (_isSavingAvatar)
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarPicker(User user, String currentAvatarId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Pilih Avatar',
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pilih karakter yang mewakili Anda di Griya Nusantara.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppColors.greyText,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: AppAvatars.all.length,
                  itemBuilder: (context, index) {
                    final avatar = AppAvatars.all[index];
                    final isSelected = avatar.id == currentAvatarId;

                    return InkWell(
                      onTap: () async {
                        Navigator.pop(sheetContext);
                        if (avatar.id != currentAvatarId) {
                          await _saveAvatar(user, avatar.id);
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: avatar.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              avatar.icon,
                              size: 32,
                              color: avatar.iconColor,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              avatar.label,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontSize: 9,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _resolveAvatarId(Map<String, dynamic> data) {
    final avatarId = data['avatarId'] as String?;
    if (avatarId != null && avatarId.isNotEmpty) {
      return avatarId;
    }
    return AppAvatars.defaultId;
  }

  String? _resolveFeaturedBadge(
    Map<String, dynamic> data,
    List<String> badges,
  ) {
    final featured = data['featuredBadge'] as String?;
    if (featured == null || featured.isEmpty) return null;
    if (badges.contains(featured)) return featured;
    return null;
  }

  Future<void> _saveFeaturedBadge(User user, String? badge) async {
    if (_isSavingBadge) return;

    setState(() => _isSavingBadge = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        badge == null
            ? {'featuredBadge': FieldValue.delete()}
            : {'featuredBadge': badge},
        SetOptions(merge: true),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              badge == null
                  ? 'Badge pajangan dihapus.'
                  : 'Badge pajangan diperbarui.',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan badge pajangan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingBadge = false);
      }
    }
  }

  void _showBadgeInfo(
    String badge, {
    bool isFeatured = false,
    User? user,
    List<String>? badges,
    String? featuredBadge,
  }) {
    final canChangeFeatured =
        isFeatured &&
        user != null &&
        badges != null &&
        !_isSavingBadge;

    BadgeUtils.showInfoDialog(
      context,
      badge,
      actions: [
        if (canChangeFeatured)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showBadgePicker(user, badges, featuredBadge);
            },
            child: Text(
              'Ubah pajangan',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                color: AppColors.greyText,
              ),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
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
  }

  void _showBadgePicker(
    User user,
    List<String> badges,
    String? currentFeatured,
  ) {
    if (badges.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Belum ada badge. Selesaikan kuis untuk dapat badge pertama!',
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Pilih Badge',
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pilih salah satu badge yang sudah Anda raih untuk ditampilkan di profil.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppColors.greyText,
                  ),
                ),
                const SizedBox(height: 16),
                if (currentFeatured != null)
                  OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(sheetContext);
                      await _saveFeaturedBadge(user, null);
                    },
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    label: const Text('Hapus badge pajangan'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.greyText,
                      side: const BorderSide(color: AppColors.border),
                    ),
                  ),
                if (currentFeatured != null) const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: badges.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final badge = badges[index];
                      final isSelected = badge == currentFeatured;
                      final style = BadgeUtils.styleFor(badge);

                      return InkWell(
                        onTap: () async {
                          Navigator.pop(sheetContext);
                          if (!isSelected) {
                            await _saveFeaturedBadge(user, badge);
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: style.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : style.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                BadgeUtils.iconFor(badge),
                                color: style.foreground,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  badge,
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    color: style.foreground,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Akun belum masuk'));
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() ?? <String, dynamic>{};
        final int xp = (data['xp'] ?? 0) as int;
        final int level = (data['level'] ?? 1) as int;
        final List<String> badges = List<String>.from(
          data['badges'] ?? <String>[],
        );
        final String? featuredBadge = _resolveFeaturedBadge(data, badges);
        final String avatarId = _resolveAvatarId(data);
        final String displayName =
            (data['name'] as String?)?.trim().isNotEmpty == true
            ? (data['name'] as String).trim()
            : (user.email?.split('@').first ?? 'Pengguna');
        final String levelTitle = _levelTitle(level);
        final int nextLevelXp = _xpForLevel(level + 1);
        final int currentLevelXp = _xpForLevel(level);
        final double progress = nextLevelXp > currentLevelXp
            ? ((xp - currentLevelXp) / (nextLevelXp - currentLevelXp)).clamp(
                0,
                1,
              )
            : 1.0;

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          children: [
            Center(
              child: Column(
                children: [
                  _buildProfileAvatar(
                    avatarId: avatarId,
                    onTap: () => _showAvatarPicker(user, avatarId),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName,
                    style: GoogleFonts.lora(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    levelTitle,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (featuredBadge != null) ...[
                    _buildFeaturedBadgeRow(
                      badge: featuredBadge,
                      onTap: _isSavingBadge
                          ? null
                          : () => _showBadgeInfo(
                              featuredBadge,
                              isFeatured: true,
                              user: user,
                              badges: badges,
                              featuredBadge: featuredBadge,
                            ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (badges.isNotEmpty && featuredBadge == null)
                    _buildSelectBadgeButton(
                      onPressed: _isSavingBadge
                          ? null
                          : () => _showBadgePicker(
                              user,
                              badges,
                              featuredBadge,
                            ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryText.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Progress Anda',
                    style: GoogleFonts.lora(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Level',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: AppColors.greyText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$level',
                              style: GoogleFonts.lora(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'XP',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: AppColors.greyText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$xp',
                              style: GoogleFonts.lora(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: progress,
                    color: AppColors.primary,
                    backgroundColor: AppColors.border,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Menuju level ${level + 1} • ${xp - currentLevelXp} / ${nextLevelXp - currentLevelXp} XP',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.greyText,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Koleksi Badge',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (badges.isEmpty)
                    Text(
                      'Belum ada badge. Selesaikan kuis untuk dapat badge pertama!',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.greyText,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: badges.map((badge) {
                        final isFeatured = badge == featuredBadge;
                        return BadgeUtils.buildBadgeChip(
                          badge,
                          isFeatured: isFeatured,
                          onTap: () => _showBadgeInfo(
                            badge,
                            isFeatured: isFeatured,
                            user: user,
                            badges: badges,
                            featuredBadge: featuredBadge,
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryText.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      'Pengaturan',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    subtitle: Text(
                      'Nama pengguna, tentang app, hapus akun',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: AppColors.greyText,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.greyText,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: AppColors.border,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.logout, color: AppColors.primary),
                    ),
                    title: Text(
                      'Keluar',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.greyText,
                    ),
                    onTap: () async {
                      final nav = Navigator.of(context);
                      await FirebaseAuth.instance.signOut();
                      nav.pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  int _xpForLevel(int level) {
    if (level <= 1) return 0;
    if (level == 2) return 200;
    if (level == 3) return 500;
    if (level == 4) return 900;
    if (level == 5) return 1500;
    return 2500;
  }

  String _levelTitle(int level) {
    switch (level) {
      case 1:
        return 'Penjelajah Budaya';
      case 2:
        return 'Pakar Daerah';
      case 3:
        return 'Nusantara Explorer';
      case 4:
        return 'Ahli Tradisi';
      case 5:
        return 'Guru Warisan';
      default:
        return 'Legenda Nusantara';
    }
  }
}
