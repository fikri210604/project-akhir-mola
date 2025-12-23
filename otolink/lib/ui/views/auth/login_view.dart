import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/ui/login_controller.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = LoginController(context);
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
          "Login",
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
              "Selamat Datang Kembali 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Masuk untuk melanjutkan ke akun Anda",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 28),
            AppTextField(
              controller: controller.emailController,
              label: 'Email/No HP',
              hint: 'Isi dengan email atau No HP Anda',
              keyboardType: TextInputType.emailAddress,
              labelColor: Theme.of(context).colorScheme.primary,
              primaryColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: controller.passwordController,
              label: 'Kata Sandi',
              hint: 'Masukkan Kata Sandi Anda',
              obscure: true,
              enableToggleObscure: true,
              labelColor: Theme.of(context).colorScheme.primary,
              primaryColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 5),
            _buildForgotPassword(),
            const SizedBox(height: 40),
            AppButton.primary(
              label: 'Masuk',
              onPressed: controller.submitLogin,
              color: Theme.of(context).colorScheme.primary,
              height: 50,
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('atau', style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            AppButton.outline(
              label: 'Masuk dengan Google',
              icon: Icons.g_mobiledata,
              onPressed: controller.signInWithGoogle,
              color: Theme.of(context).colorScheme.primary,
              height: 48,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum punya akun? ", style: TextStyle(color: Colors.grey)),
                GestureDetector(
                  onTap: () => Get.toNamed('/signup'),
                  child: Text(
                    "Daftar Sekarang",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          final email = controller.emailController.text.trim();
          if (email.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Isi email untuk reset sandi')),
            );
            return;
          }
          try {
            await Get.find<AuthController>().sendPasswordReset(email);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email reset terkirim')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        child: Text(
          'Lupa Kata Sandi?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}