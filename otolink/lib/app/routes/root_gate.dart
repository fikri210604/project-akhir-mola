import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/layouts/navigation.dart';
import '../../ui/views/home/welcome_page.dart';
import '../controllers/auth_controller.dart';

class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Obx(() {
      final user = auth.currentUser.value;
      if (user == null) return const WelcomePage();
      return const CustomNavigation();
    });
  }
}
