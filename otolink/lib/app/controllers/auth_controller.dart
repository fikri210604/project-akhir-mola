import 'package:get/get.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _service;
  final Rxn<AppUser> currentUser = Rxn<AppUser>();

  AuthController(this._service) {
    currentUser.value = _service.currentUser;
  }

  Future<void> signInAnonymously(String? displayName) async {
    final user = await _service.signInAnonymously(displayName: displayName);
    currentUser.value = user;
  }

  Future<void> signOut() async {
    await _service.signOut();
    currentUser.value = null;
  }

  Future<void> signInWithEmail(String email, String password) async {
    final user = await _service.signInWithEmailPassword(email: email, password: password);
    currentUser.value = user;
  }

  Future<void> registerWithEmail({required String email, required String password, String? displayName}) async {
    final user = await _service.registerWithEmailPassword(email: email, password: password, displayName: displayName);
    currentUser.value = user;
  }

  Future<void> sendPasswordReset(String email) => _service.sendPasswordResetEmail(email);

  Future<void> signInWithGoogle() async {
    final user = await _service.signInWithGoogle();
    currentUser.value = user;
  }

  Future<String> startPhoneAuth(String phoneNumber) async {
    final result = await _service.requestPhoneVerification(phoneNumber);
    if (result.isEmpty) {
      currentUser.value = _service.currentUser;
    }
    return result;
  }

  Future<void> confirmSmsCode(String verificationId, String smsCode) async {
    final user = await _service.verifySmsCode(verificationId: verificationId, smsCode: smsCode);
    currentUser.value = user;
  }

  Future<void> linkEmailPassword(String email, String password) async {
    await _service.linkEmailPassword(email: email, password: password);
  }

  Future<void> updateDisplayName(String displayName) async {
    await _service.updateDisplayName(displayName);
    final user = _service.currentUser;
    currentUser.value = user;
  }
}