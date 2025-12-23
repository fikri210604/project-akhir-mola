import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../../app/routes/routes.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Obx(() {
                final user = authCtrl.currentUser.value;
                if (user == null) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0A2C6C), width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/logo.png'), 
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name.isNotEmpty ? user.name : "Pengguna Otolink",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2C6C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email.isNotEmpty ? user.email : (user.phoneNumber ?? '-'),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: "Pengaturan Akun",
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: "Pusat Bantuan",
                      onTap: () => Get.toNamed(AppRoutes.help),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: "Tentang Aplikasi",
                      onTap: () {
                        Get.defaultDialog(
                          title: "Tentang Otolink",
                          content: const Column(
                            children: [
                              Icon(Icons.car_repair, size: 48, color: Color(0xFF0A2C6C)),
                              SizedBox(height: 12),
                              Text("Versi 1.0.0", style: TextStyle(color: Colors.grey)),
                              SizedBox(height: 8),
                              Text(
                                "Otolink adalah platform jual beli kendaraan terpercaya.",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          confirmTextColor: Colors.white,
                          textConfirm: "Tutup",
                          buttonColor: const Color(0xFF0A2C6C),
                          onConfirm: () => Get.back(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              TextButton.icon(
                onPressed: () {
                  Get.defaultDialog(
                    title: "Keluar",
                    middleText: "Yakin ingin keluar?",
                    textConfirm: "Ya",
                    textCancel: "Tidak",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () async {
                      await authCtrl.logout();
                      Get.offAllNamed(AppRoutes.login);
                    },
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Keluar", style: TextStyle(color: Colors.red)),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: const Color(0xFF0A2C6C), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}