import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../routes/routes.dart';
import 'base_controller.dart';

class ProfileController extends BaseController {
  final AuthService _authService;
  
  ProfileController(this._authService);

  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhoto = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void loadUser() {
    final user = _authService.currentUser;
    if (user != null) {
      userName.value = user.displayName;
      userEmail.value = user.email ?? 'Tidak ada email';
      userPhoto.value = user.photoUrl ?? '';
    } else {
      userName.value = 'Tamu';
      userEmail.value = '';
      userPhoto.value = '';
    }
  }

  Future<void> logout() async {
    await runAsync(() => _authService.signOut());
    Get.offAllNamed(AppRoutes.welcome);
  }
}