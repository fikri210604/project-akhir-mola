import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../../app/routes/routes.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notifEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0A2C6C),
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader("Akun"),
          _buildListTile(
            icon: Icons.person_outline,
            title: "Edit Profil",
            subtitle: "Ubah nama, foto, dan info lainnya",
            onTap: () {
              Get.snackbar("Info", "Fitur Edit Profil akan segera hadir", 
                backgroundColor: const Color(0xFF0A2C6C), 
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16)
              );
            },
          ),
          _buildListTile(
            icon: Icons.lock_outline,
            title: "Keamanan",
            subtitle: "Ubah kata sandi dan verifikasi",
            onTap: () {},
          ),
          const Divider(height: 32),
          _buildSectionHeader("Preferensi"),
          SwitchListTile(
            activeThumbColor: const Color(0xFF0A2C6C),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: const Text("Notifikasi Push", style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: const Text("Terima notifikasi promo dan chat", style: TextStyle(fontSize: 12, color: Colors.grey)),
            secondary: Icon(Icons.notifications_outlined, color: _notifEnabled ? const Color(0xFF0A2C6C) : Colors.grey),
            value: _notifEnabled,
            onChanged: (val) {
              setState(() => _notifEnabled = val);
              Get.snackbar(
                "Sukses", 
                val ? "Notifikasi diaktifkan" : "Notifikasi dimatikan",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black87,
                colorText: Colors.white,
                duration: const Duration(seconds: 1),
              );
            },
          ),
          SwitchListTile(
            activeThumbColor: const Color(0xFF0A2C6C),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: const Text("Mode Gelap", style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: const Text("Sesuaikan tampilan aplikasi", style: TextStyle(fontSize: 12, color: Colors.grey)),
            secondary: Icon(Icons.dark_mode_outlined, color: _darkMode ? const Color(0xFF0A2C6C) : Colors.grey),
            value: _darkMode,
            onChanged: (val) {
              setState(() => _darkMode = val);
              Get.changeTheme(val ? ThemeData.dark() : ThemeData.light());
            },
          ),
          const Divider(height: 32),
          _buildSectionHeader("Lainnya"),
          _buildListTile(
            icon: Icons.language,
            title: "Bahasa",
            subtitle: "Indonesia",
            onTap: () {},
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.defaultDialog(
                    title: "Konfirmasi Keluar",
                    middleText: "Apakah Anda yakin ingin keluar dari aplikasi?",
                    textConfirm: "Ya, Keluar",
                    textCancel: "Batal",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.redAccent,
                    cancelTextColor: Colors.black87,
                    onConfirm: () async {
                      final auth = Get.find<AuthController>();
                      await auth.logout();
                      Get.offAllNamed(AppRoutes.login);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout),
                label: const Text("Keluar Akun"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF0A2C6C),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon, 
    required String title, 
    String? subtitle, 
    required VoidCallback onTap
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF0A2C6C).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF0A2C6C), size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}