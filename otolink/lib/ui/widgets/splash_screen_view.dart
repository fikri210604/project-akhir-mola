import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../app/routes/root_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  double progressValue = 0.0;
  String statusText = "Memulai aplikasi...";

  @override
  void initState() {
    super.initState();
    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    _progressController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addListener(() {
            setState(() {
              progressValue = _progressController.value;
            });
          });

    _progressController.forward();

    await _loadSteps();

    if (!mounted) return;
    Get.offAll(() => const RootGate());
  }

  Future<void> _loadSteps() async {
    // STEP 1: Cek kredensial
    setState(() => statusText = "Mengatur kredensial...");
    await Future.delayed(const Duration(seconds: 1));

    // STEP 2: Load data awal
    setState(() => statusText = "Mengambil data awal...");
    await Future.delayed(const Duration(seconds: 1));

    // STEP 3: Setup konfigurasi (simulasi)
    setState(() => statusText = "Menyiapkan konfigurasi...");
    await Future.delayed(const Duration(seconds: 1));

    // STEP 4: Finalizing
    setState(() => statusText = "Selesai...");
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation/loading.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  color: const Color(0xFF0A2C6C),
                ),
              ),
            ),

            const SizedBox(height: 18),
            
            Text(
              statusText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0A2C6C),
                letterSpacing: .5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
