import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../../app/routes/root_gate.dart';
import '../../widgets/input_text_view.dart';
import '../../widgets/otp_fields.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String? verificationId;
  bool loading = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      _snack('Masukkan nomor HP (dengan kode negara), mis. +62xxx');
      return;
    }
    setState(() => loading = true);
    try {
      final id = await Get.find<AuthController>().startPhoneAuth(phone);
      if (id.isEmpty) {
        if (!mounted) return;
        Get.offAll(() => const RootGate());
        return;
      }
      setState(() => verificationId = id);
      _snack('Kode OTP terkirim');
    } catch (e) {
      _snack(e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _verifyCode() async {
    final code = otpController.text.trim();
    if ((verificationId ?? '').isEmpty) {
      _snack('Kirim kode dulu');
      return;
    }
    if (code.length < 4) {
      _snack('Masukkan kode OTP yang valid');
      return;
    }
    setState(() => loading = true);
    try {
      await Get.find<AuthController>().confirmSmsCode(verificationId!, code);
      if (!mounted) return;
      Get.offAll(() => const RootGate());
    } catch (e) {
      _snack(e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Nomor HP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: phoneController,
              label: 'Nomor HP',
              hint: 'Contoh: +62xxxxxxxxxx',
              keyboardType: TextInputType.phone,
              labelColor: const Color(0xFF0A2C6C),
              primaryColor: const Color(0xFF0A2C6C),
            ),
            const SizedBox(height: 12),
            AppButton.primary(
              label: loading ? 'Memproses...' : 'Kirim Kode OTP',
              onPressed: loading ? null : _sendCode,
              height: 48,
              color: const Color(0xFF0A2C6C),
            ),
            const SizedBox(height: 24),
            if (verificationId != null) ...[
              const SizedBox(height: 4),
              const Text('Kode OTP', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF0A2C6C))),
              const SizedBox(height: 6),
              OtpFields(
                length: 6,
                borderColor: Colors.grey,
                focusColor: const Color(0xFF0A2C6C),
                onChanged: (code) => otpController.text = code,
                onCompleted: (code) => otpController.text = code,
              ),
              const SizedBox(height: 16),
              AppButton.primary(
                label: loading ? 'Memproses...' : 'Verifikasi & Masuk',
                onPressed: loading ? null : _verifyCode,
                height: 48,
                color: const Color(0xFF0A2C6C),
              ),
            ],
          ],
        ),
      ),
    );
  }
}