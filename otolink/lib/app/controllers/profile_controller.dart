import 'package:get/get.dart';
import '../routes/routes.dart';
import '../services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService;
  
  ProfileController(this._authService);
  
  final RxBool isLoading = false.obs;
  final RxString userName = 'Pengguna'.obs;
  final RxString userEmail = 'guest@otolink.com'.obs;
  final RxString userInitial = 'P'.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void loadUser() {
    isLoading.value = true;
    try {
      final user = _authService.currentUser;
      if (user != null) {
        userName.value = user.displayName ?? 'Tanpa Nama';
        userEmail.value = 'user_${user.id.substring(0, 5)}@otolink.com'; 
        
        if (userName.value.isNotEmpty) {
          userInitial.value = userName.value[0].toUpperCase();
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authService.signOut();
      Get.offAllNamed(AppRoutes.welcome);
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout: $e');
    } finally {
      isLoading.value = false;
    }
  }
}