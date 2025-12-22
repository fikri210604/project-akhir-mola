import '../models/user.dart';

abstract class AuthService {
  Stream<AppUser?> get authStateChanges;
  
  Future<AppUser?> get currentUser;

  Future<void> signInWithEmail(String email, String password);
  
  Future<void> signUpWithEmail(String email, String password, String name);
  
  Future<void> signInWithGoogle();
  
  Future<void> signOut();

  Future<void> sendPasswordReset(String email);

  Future<String> startPhoneAuth(String phoneNumber);

  Future<void> confirmSmsCode(String verificationId, String smsCode);

  Future<void> updateDisplayName(String name);

  Future<void> linkEmailPassword(String email, String password);
}