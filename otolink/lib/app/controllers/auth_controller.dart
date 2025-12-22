import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  final AuthService _authService;
  
  AuthController(this._authService);

  final Rx<AppUser?> currentUser = Rx<AppUser?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.bindStream(_authService.authStateChanges);
  }

  Future<void> login(String email, String password) async {
    await signInWithEmail(email, password);
  }

  Future<void> register(String email, String password, String name) async {
    await signUpWithEmail(email, password, name);
  }

  Future<void> logout() async {
    await _authService.signOut();
  }


  Future<void> signInWithEmail(String email, String password) async {
    isLoading.value = true;
    try {
      await _authService.signInWithEmail(email, password);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    isLoading.value = true;
    try {
      await _authService.signUpWithEmail(email, password, name);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      await _authService.signInWithGoogle();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await _authService.sendPasswordReset(email);
  }

  Future<String> startPhoneAuth(String phone) async {
    return await _authService.startPhoneAuth(phone);
  }

  Future<void> confirmSmsCode(String verificationId, String code) async {
    await _authService.confirmSmsCode(verificationId, code);
  }

  Future<void> updateDisplayName(String name) async {
    await _authService.updateDisplayName(name);
  }

  Future<void> linkEmailPassword(String email, String password) async {
    await _authService.linkEmailPassword(email, password);
  }
}