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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0A2C6C)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Sign Up",
          style: TextStyle(
            color: Color(0xFF0A2C6C),
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
            const Text(
              "Silahkan Isi data diri Anda",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A2C6C),
              ),
            ),
            const SizedBox(height: 28),

            AppTextField(
              controller: controller.emailController,
              label: 'Email',
              hint: 'Masukkan Email Anda',
              keyboardType: TextInputType.emailAddress,
              labelColor: const Color(0xFF0A2C6C),
              primaryColor: const Color(0xFF0A2C6C),
            ),
            const SizedBox(height: 20),

            AppTextField(
              controller: controller.passwordController,
              label: 'Masukkan Kata Sandi',
              hint: 'Masukkan Kata Sandi Anda',
              obscure: true,
              enableToggleObscure: true,
              labelColor: const Color(0xFF0A2C6C),
              primaryColor: const Color(0xFF0A2C6C),
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
              labelColor: const Color(0xFF0A2C6C),
              primaryColor: const Color(0xFF0A2C6C),
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
              labelColor: const Color(0xFF0A2C6C),
              primaryColor: const Color(0xFF0A2C6C),
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
              color: const Color(0xFF0A2C6C),
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}