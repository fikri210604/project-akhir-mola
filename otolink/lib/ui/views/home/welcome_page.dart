import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                child: ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    height: size.height * 0.15,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Image.asset(
                'assets/images/logo.png',
                width: size.width * 0.45,
                height: size.width * 0.45,
                errorBuilder: (_,__,___) => Icon(Icons.car_repair, size: 100, color: theme.colorScheme.primary),
              ),

              const SizedBox(height: 16),

              Text(
                'OtoLink',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Pusatnya Ngedeal Kendaraan Bermotor dan Elektronik!', 
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              Text(
                'Selamat Datang di OtoLink!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              _buildButton(
                context,
                icon: Icons.login_rounded,
                label: 'Login / Masuk',
                onTap: () => Get.toNamed(AppRoutes.login),
              ),

              const SizedBox(height: 12),

              _buildButton(
                context,
                icon: Icons.person_add_alt_1,
                label: 'Sign Up / Daftar',
                onTap: () => Get.toNamed(AppRoutes.signup),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Dengan masuk, Anda menyetujui\nSyarat, Ketentuan & Kebijakan Privasi OtoLink',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[500] : Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.5, size.height - 40, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}