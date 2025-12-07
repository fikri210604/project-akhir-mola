import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Get.find<ProfileController>().loadUser());
  }

  @override
  Widget build(BuildContext context) {
    final profile = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', width: 35),
            const SizedBox(width: 8),
            const Text(
              'OtoLink',
              style: TextStyle(
                color: Color(0xFF0A2C6C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() => profile.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0A2C6C),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          const AssetImage('assets/images/profile.jpg'),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    profile.userName.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A2C6C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.userEmail.value,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Tombol Edit Profil
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Menu edit profil coming soon!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A2C6C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Lihat dan edit profil",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Menu Menu
                  _buildMenuItem(
                    icon: Icons.shopping_cart_outlined,
                    title: "Pesanan & Booking",
                    subtitle: "Booking, Paket & Pesanan",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: "Pengaturan",
                    subtitle: "Privasi dan logout",
                    onTap: () => profile.logout(),
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: "Pusat Bantuan",
                    subtitle: "Ajukan Pengaduan",
                    onTap: () {},
                  ),
                ],
              ),
            )),
    );
  }

  // 🔹 Komponen Menu Reusable
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0A2C6C).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0A2C6C)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A2C6C),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xFF0A2C6C),
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}
