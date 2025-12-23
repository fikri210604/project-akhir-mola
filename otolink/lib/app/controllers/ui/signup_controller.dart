import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../../routes/root_gate.dart';

class SignupController {
  final BuildContext context;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();

  SignupController(this.context);

  Future<void> submitSignup() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;
    final username = usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty || username.isEmpty) {
      _snack('Semua field wajib diisi');
      return;
    }
    if (password.length < 8) {
      _snack('Kata sandi minimal 8 karakter');
      return;
    }
    if (password != confirm) {
      _snack('Konfirmasi kata sandi tidak cocok');
      return;
    }
    try {
      await Get.find<AuthController>().register(email, password, username);
      Get.offAll(() => const RootGate());
    } catch (e) {
      _snack(e.toString());
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
  }
}