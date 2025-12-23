import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/ui/signup_controller.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late SignupController controller;

  @override
  void initState() {
    super.initState();
    controller = SignupController(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.8,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Sign Up",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Silahkan Isi data diri Anda",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Daftar untuk membuat akun baru",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 28),
            AppTextField(
              controller: controller.emailController,
              label: 'Email',
              hint: 'Masukkan Email Anda',
              keyboardType: TextInputType.emailAddress,
              labelColor: Theme.of(context).colorScheme.primary,
              primaryColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: controller.passwordController,
              label: 'Masukkan Kata Sandi',
              hint: 'Masukkan Kata Sandi Anda',
              obscure: true,
              enableToggleObscure: true,
              labelColor: Theme.of(context).colorScheme.primary,
              primaryColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 5),
            const Text(
              "*Minimal 8 karakter. Harus menyertakan kombinasi angka, huruf dan karakter",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: controller.confirmPasswordController,
              label: 'Konfirmasi Kata Sandi',
              hint: 'Masukkan Kata Sandi Anda',
              obscure: true,
              enableToggleObscure: true,
              labelColor: Theme.of(context).colorScheme.primary,
              primaryColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 5),
            const Text(
              "*Harus menyertakan kombinasi angka, huruf dan karakter",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: controller.usernameController,
              label: 'Masukkan Username',
              hint: 'Masukkan Username Anda',
              labelColor: Theme.of(context).colorScheme.primary,
              primaryColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 5),
            const Text(
              "*Harus menyertakan kombinasi angka, huruf dan karakter",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            AppButton.primary(
              label: 'Lanjut',
              onPressed: controller.submitSignup,
              color: Theme.of(context).colorScheme.primary,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}