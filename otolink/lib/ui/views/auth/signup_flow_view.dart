import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/ui/signup_flow_controller.dart';
import '../../widgets/input_text_view.dart';
import '../../widgets/otp_fields.dart';
import '../../../app/routes/root_gate.dart';

class SignupFlowPage extends StatefulWidget {
  const SignupFlowPage({super.key});

  @override
  State<SignupFlowPage> createState() => _SignupFlowPageState();
}

class _SignupFlowPageState extends State<SignupFlowPage> {
  late SignupFlowController controller;
  int step = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    controller = SignupFlowController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    setState(() => loading = true);
    final id = await controller.sendCode(context);
    if (!mounted) return;
    
    setState(() {
      loading = false;
      // Hanya lanjut jika id tidak null
      if (id != null) {
        step = (id.isEmpty) ? 3 : 2;
      }
    });
  }

  Future<void> _verifyCode() async {
    setState(() => loading = true);
    final ok = await controller.verifyCode(context);
    if (!mounted) return;
    setState(() {
      loading = false;
      if (ok) step = 3;
    });
  }

  Future<void> _submitFinal() async {
    setState(() => loading = true);
    final ok = await controller.submitFinal(context);
    if (!mounted) return;
    setState(() => loading = false);
    if (ok) Get.offAll(() => const RootGate());
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
          'Daftar Akun',
          style: TextStyle(color: Color(0xFF0A2C6C), fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepper(),
              const SizedBox(height: 20),
              if (step == 1) _buildPhoneStep(),
              if (step == 2) _buildOtpStep(),
              if (step == 3) _buildDetailsStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    final active = const Color(0xFF0A2C6C);
    final inactive = Colors.grey.shade300;
    Widget dot(bool on) => Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on ? active : inactive,
            shape: BoxShape.circle,
          ),
          child: Text(
            on ? '✓' : '',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
    Widget bar(bool on) => Expanded(
          child: Container(height: 4, color: on ? active : inactive),
        );

    return Row(
      children: [
        dot(step > 1),
        bar(step > 1),
        dot(step > 2),
        bar(step > 2),
        dot(false),
      ],
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Langkah 1: Nomor Telepon',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0A2C6C)),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: controller.phoneController,
          label: 'Nomor HP (dengan kode negara)',
          hint: 'Contoh: +62xxxxxxxxxx',
          keyboardType: TextInputType.phone,
          labelColor: const Color(0xFF0A2C6C),
          primaryColor: const Color(0xFF0A2C6C),
        ),
        const SizedBox(height: 18),
        AppButton.primary(
          label: loading ? 'Memproses...' : 'Lanjut',
          onPressed: loading ? null : _sendCode,
          height: 50,
          color: const Color(0xFF0A2C6C),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Langkah 2: Verifikasi OTP',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0A2C6C)),
        ),
        const SizedBox(height: 16),
        const Text('Kode OTP', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF0A2C6C))),
        const SizedBox(height: 6),
        OtpFields(
          length: 6,
          borderColor: Colors.grey,
          focusColor: const Color(0xFF0A2C6C),
          onChanged: (code) => controller.otpController.text = code,
          onCompleted: (code) => controller.otpController.text = code,
        ),
        const SizedBox(height: 18),
        AppButton.primary(
          label: loading ? 'Memproses...' : 'Lanjut',
          onPressed: loading ? null : _verifyCode,
          height: 50,
          color: const Color(0xFF0A2C6C),
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Langkah 3: Data Pendukung',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0A2C6C)),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: controller.usernameController,
          label: 'Username',
          hint: 'Nama tampilan Anda',
          labelColor: const Color(0xFF0A2C6C),
          primaryColor: const Color(0xFF0A2C6C),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: controller.emailController,
          label: 'Email',
          hint: 'Masukkan email aktif',
          keyboardType: TextInputType.emailAddress,
          labelColor: const Color(0xFF0A2C6C),
          primaryColor: const Color(0xFF0A2C6C),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: controller.passwordController,
          label: 'Kata Sandi',
          hint: 'Minimal 8 karakter',
          obscure: true,
          enableToggleObscure: true,
          labelColor: const Color(0xFF0A2C6C),
          primaryColor: const Color(0xFF0A2C6C),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: controller.confirmPasswordController,
          label: 'Konfirmasi Kata Sandi',
          hint: 'Ulangi kata sandi',
          obscure: true,
          enableToggleObscure: true,
          labelColor: const Color(0xFF0A2C6C),
          primaryColor: const Color(0xFF0A2C6C),
        ),
        const SizedBox(height: 20),
        AppButton.primary(
          label: loading ? 'Memproses...' : 'Lanjut',
          onPressed: loading ? null : _submitFinal,
          height: 50,
          color: const Color(0xFF0A2C6C),
        ),
      ],
    );
  }
}