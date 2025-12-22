import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../../app/routes/routes.dart';
import '../products/my_products_view.dart';
import '../auth/login_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Obx(() {
                final user = authCtrl.currentUser.value;
                if (user == null) {
                  return Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Get.to(() => const LoginPage()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A2C6C),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Login / Register"),
                      ),
                    ],
                  );
                }
                
                final hasPhoto = user.photoUrl != null && user.photoUrl!.isNotEmpty;
                
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF0A2C6C),
                      backgroundImage: hasPhoto
                          ? NetworkImage(user.photoUrl!) 
                          : null,
                      child: !hasPhoto
                          ? Text(
                              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                              style: const TextStyle(fontSize: 32, color: Colors.white),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black,
                        elevation: 0,
                      ),
                      child: const Text("Edit Profil"),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 40),

              _buildMenuTile(
                icon: Icons.inventory_2_outlined,
                title: "Produk Saya",
                onTap: () {
                  final user = authCtrl.currentUser.value;
                  if (user == null) {
                    Get.to(() => const LoginPage());
                  } else {
                    Get.to(() => const MyProductsView());
                  }
                },
              ),
              
              _buildMenuTile(
                icon: Icons.settings_outlined,
                title: "Pengaturan",
                onTap: () {},
              ),
              
              _buildMenuTile(
                icon: Icons.help_outline,
                title: "Bantuan",
                onTap: () {},
              ),

              Obx(() {
                if (authCtrl.currentUser.value != null) {
                  return Column(
                    children: [
                      const Divider(),
                      _buildMenuTile(
                        icon: Icons.logout,
                        title: "Keluar",
                        color: Colors.red,
                        onTap: () {
                          authCtrl.logout();
                          Get.offAllNamed(AppRoutes.login);
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon, 
    required String title, 
    required VoidCallback onTap,
    Color color = Colors.black87
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title, 
        style: TextStyle(fontWeight: FontWeight.w500, color: color)
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}