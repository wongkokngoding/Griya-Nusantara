import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'theme/app_text_styles.dart';
import 'utils/responsive_helper.dart';

class FeedbackScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;

  const FeedbackScreen({
    super.key,
    required this.initialName,
    required this.initialEmail,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();

  final bool _isLoading = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _emailController.text = widget.initialEmail;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'userId': user?.uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'feedback': _feedbackController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: Text(
            'Berhasil',
            style: AppTextStyles.loraBoldSecondary.copyWith(fontSize: 18.sf),
          ),
          content: Text(
            'Terima kasih! Saran dan masukan Anda telah terkirim.',
            style: AppTextStyles.manropeBody.copyWith(fontSize: 14.sf),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'OK',
                style: AppTextStyles.manropeBoldPrimary.copyWith(
                  fontSize: 14.sf,
                ),
              ),
            ),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(
            'Gagal',
            style: AppTextStyles.loraBoldSecondary.copyWith(fontSize: 18.sf),
          ),
          content: Text(
            'Gagal mengirim masukan: $e',
            style: AppTextStyles.manropeBody.copyWith(fontSize: 14.sf),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Tutup',
                style: AppTextStyles.manropeBoldPrimary.copyWith(
                  fontSize: 14.sf,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.secondaryText,
        title: Text(
          'Saran dan Masukan',
          style: AppTextStyles.loraBoldSecondary.copyWith(fontSize: 20.sf),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.sw, 16.sh, 24.sw, 32.sh),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kami sangat menghargai saran dan masukan Anda untuk membantu kami menjadi lebih baik.',
                      style: AppTextStyles.manropeBody.copyWith(
                        fontSize: 14.sf,
                        color: AppColors.greyText,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24.sh),

                    // Input Nama
                    Text(
                      'Nama Pengguna',
                      style: AppTextStyles.manropeSemi14.copyWith(
                        fontSize: 14.sf,
                      ),
                    ),
                    SizedBox(height: 8.sh),
                    TextFormField(
                      controller: _nameController,
                      readOnly: true,
                      style: AppTextStyles.manropeField14.copyWith(
                        fontSize: 14.sf,
                        color: AppColors.greyText,
                      ),
                      decoration: _inputDecoration('Nama Pengguna').copyWith(
                        fillColor: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    SizedBox(height: 16.sh),

                    // Input Email
                    Text(
                      'Email',
                      style: AppTextStyles.manropeSemi14.copyWith(
                        fontSize: 14.sf,
                      ),
                    ),
                    SizedBox(height: 8.sh),
                    TextFormField(
                      controller: _emailController,
                      readOnly: true,
                      style: AppTextStyles.manropeField14.copyWith(
                        fontSize: 14.sf,
                        color: AppColors.greyText,
                      ),
                      decoration: _inputDecoration('Email').copyWith(
                        fillColor: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    SizedBox(height: 16.sh),

                    // Input Masukan
                    Text(
                      'Saran / Masukan',
                      style: AppTextStyles.manropeSemi14.copyWith(
                        fontSize: 14.sf,
                      ),
                    ),
                    SizedBox(height: 8.sh),
                    TextFormField(
                      controller: _feedbackController,
                      enabled: !_isSubmitting,
                      maxLines: 6,
                      style: AppTextStyles.manropeField14.copyWith(
                        fontSize: 14.sf,
                      ),
                      decoration: _inputDecoration(
                        'Tulis saran atau masukan Anda di sini...',
                      ).copyWith(alignLabelWithHint: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Saran atau masukan tidak boleh kosong';
                        }
                        if (value.trim().length < 10) {
                          return 'Saran atau masukan minimal 10 karakter';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32.sh),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.sh,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Kirim',
                                style: AppTextStyles.manropeBold.copyWith(
                                  fontSize: 16.sf,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.manropeHint14.copyWith(fontSize: 14.sf),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sh),
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
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorStyle: AppTextStyles.manropeError12.copyWith(fontSize: 12.sf),
    );
  }
}
