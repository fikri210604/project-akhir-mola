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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('account'.tr),
          _buildListTile(
            icon: Icons.person_outline,
            title: 'edit_profile'.tr,
            subtitle: 'edit_profile_desc'.tr,
            onTap: () {
              Get.snackbar('settings'.tr, 'info_feature'.tr, 
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16)
              );
            },
          ),
          _buildListTile(
            icon: Icons.lock_outline,
            title: 'security'.tr,
            subtitle: 'security_desc'.tr,
            onTap: () {},
          ),
          const Divider(height: 32),
          _buildSectionHeader('preferences'.tr),
          SwitchListTile(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: Text('push_notif'.tr, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('push_notif_desc'.tr, style: const TextStyle(fontSize: 12)),
            secondary: Icon(Icons.notifications_outlined, color: _notifEnabled ? Theme.of(context).colorScheme.primary : Colors.grey),
            value: _notifEnabled,
            onChanged: (val) {
              setState(() => _notifEnabled = val);
              Get.snackbar(
                'success'.tr, 
                val ? 'notif_on'.tr : 'notif_off'.tr,
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 1),
              );
            },
          ),
          SwitchListTile(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: Text('dark_mode'.tr, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('dark_mode_desc'.tr, style: const TextStyle(fontSize: 12)),
            secondary: Icon(Icons.dark_mode_outlined, color: Get.isDarkMode ? Theme.of(context).colorScheme.primary : Colors.grey),
            value: Get.isDarkMode,
            onChanged: (val) {
              Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          const Divider(height: 32),
          _buildSectionHeader('others'.tr),
          _buildListTile(
            icon: Icons.language,
            title: 'language'.tr,
            subtitle: _getCurrentLangName(),
            onTap: () => _showLanguageDialog(),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'logout_confirm'.tr,
                    middleText: 'logout_msg'.tr,
                    textConfirm: 'yes_logout'.tr,
                    textCancel: 'cancel'.tr,
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.redAccent,
                    onConfirm: () async {
                      final auth = Get.find<AuthController>();
                      await auth.logout();
                      Get.offAllNamed(AppRoutes.login);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout),
                label: Text('logout_account'.tr),
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
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
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
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  String _getCurrentLangName() {
    final locale = Get.locale?.toString() ?? 'id_ID';
    switch (locale) {
      case 'id_ID': return 'Bahasa Indonesia';
      case 'en_US': return 'English';
      case 'de_DE': return 'Deutsch';
      case 'ja_JP': return '日本語';
      case 'ar_SA': return 'العربية';
      default: return 'Bahasa Indonesia';
    }
  }

  void _showLanguageDialog() {
    Get.bottomSheet(
      Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Wrap(
          children: [
            ListTile(
              leading: const Text('🇮🇩'),
              title: const Text('Bahasa Indonesia'),
              onTap: () { Get.updateLocale(const Locale('id', 'ID')); Get.back(); setState((){}); },
            ),
            ListTile(
              leading: const Text('🇺🇸'),
              title: const Text('English'),
              onTap: () { Get.updateLocale(const Locale('en', 'US')); Get.back(); setState((){}); },
            ),
            ListTile(
              leading: const Text('🇩🇪'),
              title: const Text('Deutsch'),
              onTap: () { Get.updateLocale(const Locale('de', 'DE')); Get.back(); setState((){}); },
            ),
            ListTile(
              leading: const Text('🇯🇵'),
              title: const Text('日本語 (Japanese)'),
              onTap: () { Get.updateLocale(const Locale('ja', 'JP')); Get.back(); setState((){}); },
            ),
            ListTile(
              leading: const Text('🇸🇦'),
              title: const Text('العربية (Arabic)'),
              onTap: () { Get.updateLocale(const Locale('ar', 'SA')); Get.back(); setState((){}); },
            ),
          ],
        ),
      ),
    );
  }
}