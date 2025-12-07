import 'dart:math';

import '../../models/user.dart';
import '../auth_service.dart';

class MemoryAuthService implements AuthService {
  AppUser? _user;
  String? _lastVerificationId;
  String? _lastPhone;

  @override
  AppUser? get currentUser => _user;

  @override
  Future<AppUser> signInAnonymously({String? displayName}) async {
    final id = 'u_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    _user = AppUser(id: id, displayName: displayName?.trim().isNotEmpty == true ? displayName!.trim() : 'Guest');
    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
  }

  @override
  Future<AppUser> signInWithEmailPassword({required String email, required String password}) async {
    // For demo: accept any email/password and set displayName from email prefix
    final name = email.split('@').first;
    _user = AppUser(id: 'mem_$name', displayName: name);
    return _user!;
  }

  @override
  Future<AppUser> registerWithEmailPassword({required String email, required String password, String? displayName}) async {
    final name = (displayName ?? email.split('@').first).trim();
    _user = AppUser(id: 'mem_$name', displayName: name);
    return _user!;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // no-op in memory
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final id = 'mem_google_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    _user = AppUser(id: id, displayName: 'Mem Google User');
    return _user!;
  }

  @override
  Future<String> requestPhoneVerification(String phoneNumber) async {
    // Simulate sending OTP and return a verificationId
    _lastVerificationId = 'mem_verif_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    _lastPhone = phoneNumber;
    return _lastVerificationId!;
  }

  @override
  Future<AppUser> verifySmsCode({required String verificationId, required String smsCode}) async {
    // In-memory: accept any code if verificationId matches the last issued id
    if (_lastVerificationId == null || verificationId != _lastVerificationId) {
      throw Exception('VerificationId tidak dikenal');
    }
    final phone = (_lastPhone ?? 'phone');
    final id = 'mem_phone_${phone.replaceAll(RegExp(r'[^0-9+]'), '')}';
    _user = AppUser(id: id, displayName: 'Mem Phone User');
    // clear state
    _lastVerificationId = null;
    _lastPhone = null;
    return _user!;
  }

  @override
  Future<void> linkEmailPassword({required String email, required String password}) async {
    // In-memory implementation: no persistence; assume success
    return;
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    if (_user != null) {
      _user = AppUser(id: _user!.id, displayName: displayName, photoUrl: _user!.photoUrl);
    }
  }
}
