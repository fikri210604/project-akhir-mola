import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../../routes/root_gate.dart';

class LoginController {
  final BuildContext context;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginController(this.context);

  Future<void> submitLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Email dan kata sandi wajib diisi');
      return;
    }

    try {
      await Get.find<AuthController>().signInWithEmail(email, password);
      if (!context.mounted) return;
      Get.offAll(() => const RootGate());
    } catch (e) {
      _showSnack(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await Get.find<AuthController>().signInWithGoogle();
      if (!context.mounted) return;
      Get.offAll(() => const RootGate());
    } catch (e) {
      _showSnack(e.toString());
    }
  }

  void _showSnack(String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}