import 'package:get/get.dart';
import '../services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService;

  ProfileController(this._authService);

  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userPhoto = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  void _loadProfile() async {
    final user = await _authService.currentUser;
    if (user != null) {
      userName.value = user.name;
      userEmail.value = user.email;
      userPhoto.value = user.photoUrl ?? '';
    }
  }
}