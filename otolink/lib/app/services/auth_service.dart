import '../models/user.dart';

abstract class AuthService {
  AppUser? get currentUser;

  // Anonymous
  Future<AppUser> signInAnonymously({String? displayName});

  // Email & password
  Future<AppUser> signInWithEmailPassword({required String email, required String password});
  Future<AppUser> registerWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  });
  Future<void> sendPasswordResetEmail(String email);

  // Google Sign-In
  Future<AppUser> signInWithGoogle();

  // Phone (OTP) Sign-In
  // Starts phone verification and returns verificationId when code is sent.
  Future<String> requestPhoneVerification(String phoneNumber);
  // Confirms the SMS code to sign in.
  Future<AppUser> verifySmsCode({required String verificationId, required String smsCode});

  Future<void> signOut();

  // Link email/password to current signed-in user (e.g., after phone auth)
  Future<void> linkEmailPassword({required String email, required String password});

  // Update display name of current user
  Future<void> updateDisplayName(String displayName);
}
