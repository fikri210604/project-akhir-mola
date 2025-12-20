import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/profile_controller.dart';
import '../../../app/services/auth_service.dart';
import '../../../app/routes/routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController(Get.find<AuthService>()));
    }
    
    final profile = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', width: 35, errorBuilder: (c, o, s) => const Icon(Icons.car_repair, color: Colors.indigo)),
            const SizedBox(width: 8),
            const Text('OtoLink', style: TextStyle(color: Color(0xFF0A2C6C), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Obx(() {
        if (profile.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF0A2C6C)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF0A2C6C),
                  child: Text(
                    profile.userInitial.value,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(profile.userName.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0A2C6C))),
              const SizedBox(height: 4),
              Text(profile.userEmail.value, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.snackbar('Info', 'Fitur edit profil belum tersedia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2C6C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Lihat dan edit profil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),

              _buildMenuItem(
                icon: Icons.favorite_border,
                title: "Favorit Saya",
                subtitle: "Produk yang Anda simpan",
                onTap: () => Get.toNamed(AppRoutes.favorites),
              ),
              _buildMenuItem(
                icon: Icons.shopping_cart_outlined,
                title: "Pesanan & Booking",
                subtitle: "Booking, Paket & Pesanan",
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: "Pengaturan",
                subtitle: "Privasi dan keamanan",
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: "Keluar",
                subtitle: "Logout dari akun",
                onTap: () => _showLogoutDialog(context, profile),
                isDestructive: true,
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(onPressed: () { Get.back(); controller.logout(); }, child: const Text('Keluar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required String subtitle, required VoidCallback onTap, bool isDestructive = false}) {
    final color = isDestructive ? Colors.red : const Color(0xFF0A2C6C);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: color.withOpacity(0.5), size: 18),
        onTap: onTap,
      ),
    );
  }
}