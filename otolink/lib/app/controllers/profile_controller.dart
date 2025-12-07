import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;

import '../routes/routes.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString userName = '-'.obs;
  final RxString userEmail = '-'.obs;

  Future<void> loadUser() async {
    isLoading.value = true;
    try {
      final auth = Get.find<AuthController>();
      final appUser = auth.currentUser.value;
      userName.value = appUser?.displayName ?? 'Guest';

      final email = fa.FirebaseAuth.instance.currentUser?.email;
      userEmail.value = email ?? '-';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await Get.find<AuthController>().signOut();
      Get.offAllNamed(AppRoutes.welcome);
    } finally {
      isLoading.value = false;
    }
  }
}

