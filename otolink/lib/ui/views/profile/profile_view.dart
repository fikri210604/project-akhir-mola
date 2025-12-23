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
                        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        backgroundImage: const AssetImage('assets/images/logo.png'), 
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name.isNotEmpty ? user.name : 'user_default'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
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
                      context,
                      icon: Icons.settings_outlined,
                      title: 'account_settings'.tr,
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      icon: Icons.help_outline,
                      title: 'help_center'.tr,
                      onTap: () => Get.toNamed(AppRoutes.help),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      icon: Icons.info_outline,
                      title: 'about_app'.tr,
                      onTap: () {
                        Get.defaultDialog(
                          title: 'about_app'.tr,
                          content: Column(
                            children: [
                              Icon(Icons.car_repair, size: 48, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(height: 12),
                              const Text("Versi 1.0.0", style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              const Text(
                                "Otolink Platform",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          confirmTextColor: Colors.white,
                          textConfirm: "OK",
                          buttonColor: Theme.of(context).colorScheme.primary,
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
                    title: 'logout_confirm'.tr,
                    middleText: 'logout_msg'.tr,
                    textConfirm: 'yes_logout'.tr,
                    textCancel: 'cancel'.tr,
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () async {
                      await authCtrl.logout();
                      Get.offAllNamed(AppRoutes.login);
                    },
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text('logout'.tr, style: const TextStyle(color: Colors.red)),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark 
          ? Colors.grey.shade900 
          : Colors.grey.shade50,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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