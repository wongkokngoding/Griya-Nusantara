import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'constants/app_info.dart';
import 'login_screen.dart';
import 'theme/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _displayName = 'Pengguna';
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadDisplayName();
  }

  Future<void> _loadDisplayName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoadingUser = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!mounted) return;
      setState(() {
        _displayName = _nameFromData(doc.data(), user);
        _isLoadingUser = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _displayName = user.email?.split('@').first ?? 'Pengguna';
          _isLoadingUser = false;
        });
      }
    }
  }

  String _nameFromData(Map<String, dynamic>? data, User user) {
    final name = (data?['name'] as String?)?.trim();
    if (name != null && name.isNotEmpty) return name;
    return user.email?.split('@').first ?? 'Pengguna';
  }

  Future<void> _openEditUsernameDialog(User user) async {
    final newName = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return _EditUsernameDialog(
          initialName: _displayName,
          userId: user.uid,
        );
      },
    );

    if (newName == null || !mounted) return;
    if (newName == _displayName) return;

    setState(() => _displayName = newName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Nama pengguna berhasil diperbarui.',
          style: AppTextStyles.manropeBody,
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Tentang Aplikasi', style: AppTextStyles.loraBoldSecondary),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.account_balance_rounded,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(AppInfo.name, style: AppTextStyles.loraBoldSecondary20),
              const SizedBox(height: 6),
              Text(
                'Versi ${AppInfo.versionLabel}',
                style: AppTextStyles.manropeBody13Grey,
              ),
              const SizedBox(height: 12),
              Text(
                'Aplikasi edukasi rumah adat Indonesia.',
                textAlign: TextAlign.center,
                style: AppTextStyles.manropeBody.copyWith(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Tutup', style: AppTextStyles.manropeBoldPrimary),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(User user) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Hapus Akun', style: AppTextStyles.loraBoldSecondary),
              content: Text(
                'Apakah Anda yakin ingin menghapus akun ini? '
                'Semua data profil akan dihapus dan tindakan ini tidak dapat dibatalkan.',
                style: AppTextStyles.manropeBody.copyWith(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
                  child: Text(
                    'Batal',
                    style: AppTextStyles.manropeSemi14.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setDialogState(() => isLoading = true);
                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .delete();
                            await user.delete();
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                            }
                            if (!context.mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          } on FirebaseAuthException catch (e) {
                            setDialogState(() => isLoading = false);
                            String errorMsg =
                                'Gagal menghapus akun: ${e.message}';
                            if (e.code == 'requires-recent-login') {
                              errorMsg =
                                  'Sesi telah kedaluwarsa. Silakan keluar, masuk kembali, lalu coba lagi.';
                            }
                            if (dialogContext.mounted) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    errorMsg,
                                    style: AppTextStyles.manropeBody,
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            setDialogState(() => isLoading = false);
                            if (dialogContext.mounted) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Terjadi kesalahan: $e',
                                    style: AppTextStyles.manropeBody,
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Hapus',
                          style: AppTextStyles.manropeBold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _menuTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: AppTextStyles.manropeBold.copyWith(
          color: titleColor ?? AppColors.secondaryText,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTextStyles.manropeBody13Grey)
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.greyText),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.secondaryText,
        title: Text('Pengaturan', style: AppTextStyles.loraBoldSecondary),
      ),
      body: user == null
          ? Center(
              child: Text('Akun belum masuk', style: AppTextStyles.manropeBody),
            )
          : _isLoadingUser
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              children: [
                _settingsCard(
                  children: [
                    _menuTile(
                      icon: Icons.person_outline_rounded,
                      iconBg: AppColors.primary.withValues(alpha: 0.1),
                      iconColor: AppColors.primary,
                      title: 'Edit Nama Pengguna',
                      subtitle: _displayName,
                      onTap: () => _openEditUsernameDialog(user),
                    ),
                    const Divider(
                      color: AppColors.border,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _menuTile(
                      icon: Icons.info_outline_rounded,
                      iconBg: AppColors.primary.withValues(alpha: 0.1),
                      iconColor: AppColors.primary,
                      title: 'Tentang Aplikasi',
                      subtitle: '${AppInfo.name} • v${AppInfo.versionLabel}',
                      onTap: _showAboutDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Akun',
                  style: AppTextStyles.manropeSemi14.copyWith(
                    fontSize: 13,
                    color: AppColors.greyText,
                  ),
                ),
                const SizedBox(height: 8),
                _settingsCard(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.border.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.greyText,
                        ),
                      ),
                      title: Text(
                        'Email',
                        style: AppTextStyles.manropeBold.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      subtitle: Text(
                        user.email ?? '-',
                        style: AppTextStyles.manropeBody13Grey,
                      ),
                    ),
                    const Divider(
                      color: AppColors.border,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _menuTile(
                      icon: Icons.delete_forever_rounded,
                      iconBg: Colors.red.withValues(alpha: 0.1),
                      iconColor: Colors.red,
                      title: 'Hapus Akun',
                      subtitle: 'Hapus akun dan data profil secara permanen',
                      titleColor: Colors.red,
                      onTap: () => _showDeleteAccountDialog(user),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
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
      child: Column(children: children),
    );
  }
}

/// Dialog edit nama — simpan ke Firestore di dalam dialog agar halaman induk tidak rebuild berat.
class _EditUsernameDialog extends StatefulWidget {
  const _EditUsernameDialog({
    required this.initialName,
    required this.userId,
  });

  final String initialName;
  final String userId;

  @override
  State<_EditUsernameDialog> createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends State<_EditUsernameDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() != true || _isSaving) return;

    final newName = _controller.text.trim();
    if (newName == widget.initialName) {
      Navigator.of(context).pop(newName);
      return;
    }

    setState(() => _isSaving = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({'name': newName});
      if (!mounted) return;
      Navigator.of(context).pop(newName);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan nama: $e',
            style: AppTextStyles.manropeBody,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Nama Pengguna', style: AppTextStyles.loraBoldSecondary),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Pengguna', style: AppTextStyles.manropeSemi14),
            const SizedBox(height: 8),
            TextFormField(
              controller: _controller,
              enabled: !_isSaving,
              textCapitalization: TextCapitalization.words,
              style: AppTextStyles.manropeField14,
              decoration: InputDecoration(
                hintText: 'Masukkan nama Anda',
                hintStyle: AppTextStyles.manropeHint14,
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                errorStyle: AppTextStyles.manropeError12,
              ),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return 'Nama tidak boleh kosong';
                if (trimmed.length < 2) return 'Minimal 2 karakter';
                if (trimmed.length > 32) return 'Maksimal 32 karakter';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Batal',
            style: AppTextStyles.manropeSemi14.copyWith(
              color: AppColors.greyText,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text('Simpan', style: AppTextStyles.manropeBold),
        ),
      ],
    );
  }
}
