import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';

class SignupFlowController {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();

  String? verificationId;

  Future<String?> sendCode(BuildContext context) async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty || !phone.startsWith('+')) {
      _snack(context, 'Masukkan nomor dengan kode negara, mis. +62xxxxxxxx');
      return null;
    }
    try {
      final id = await Get.find<AuthController>().startPhoneAuth(phone);
      verificationId = id.isEmpty ? null : id;
      
      if (!context.mounted) return null;

      if (id.isEmpty) {
        _snack(context, 'Nomor terverifikasi otomatis');
      } else {
        _snack(context, 'Kode OTP terkirim');
      }
      return id;
    } catch (e) {
      if (context.mounted) _snack(context, e.toString());
      return null;
    }
  }

  Future<bool> verifyCode(BuildContext context) async {
    final code = otpController.text.trim();
    if ((verificationId ?? '').isEmpty) {
      _snack(context, 'Kirim kode dulu');
      return false;
    }
    if (code.length < 4) {
      _snack(context, 'Masukkan kode OTP yang valid');
      return false;
    }
    try {
      await Get.find<AuthController>().confirmSmsCode(verificationId!, code);
      if (context.mounted) _snack(context, 'OTP terverifikasi');
      return true;
    } catch (e) {
      if (context.mounted) _snack(context, e.toString());
      return false;
    }
  }

  Future<bool> submitFinal(BuildContext context) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (username.isEmpty) {
      _snack(context, 'Username wajib diisi');
      return false;
    }

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _snack(context, 'Email dan kata sandi wajib diisi');
      return false;
    }
    if (password.length < 8) {
      _snack(context, 'Kata sandi minimal 8 karakter');
      return false;
    }
    if (password != confirm) {
      _snack(context, 'Konfirmasi kata sandi tidak cocok');
      return false;
    }

    try {
      final auth = Get.find<AuthController>();
      if (auth.currentUser.value == null) {
        throw Exception('Sesi berakhir, silakan ulangi verifikasi nomor HP');
      }
      await auth.updateDisplayName(username);
      await auth.linkEmailPassword(email, password);
      return true;
    } catch (e) {
      if (context.mounted) _snack(context, e.toString());
      return false;
    }
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
  }
}