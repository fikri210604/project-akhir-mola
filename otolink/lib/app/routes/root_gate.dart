import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../../ui/layouts/navigation.dart';
import '../../ui/views/home/welcome_page.dart';

class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = Get.find<AuthController>().currentUser.value;
      
      if (user != null) {
        return const Navigation(); 
      } else {
        return const WelcomePage();
      }
    });
  }
}