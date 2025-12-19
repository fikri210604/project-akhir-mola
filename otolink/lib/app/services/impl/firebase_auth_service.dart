import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/user.dart';
import '../auth_service.dart';

class FirebaseAuthService implements AuthService {
  final fa.FirebaseAuth _auth;
  fa.ConfirmationResult? _webConfirmationResult;

  FirebaseAuthService({fa.FirebaseAuth? auth}) : _auth = auth ?? fa.FirebaseAuth.instance;

  AppUser? _mapUser(fa.User? user) {
    if (user == null) return null;
    return AppUser(id: user.uid, displayName: user.displayName ?? 'Guest', photoUrl: user.photoURL);
  }

  @override
  AppUser? get currentUser => _mapUser(_auth.currentUser);

  @override
  Future<AppUser> signInAnonymously({String? displayName}) async {
    final cred = await _auth.signInAnonymously();
    final user = cred.user!;
    if ((displayName ?? '').trim().isNotEmpty) {
      await user.updateDisplayName(displayName!.trim());
    }
    return _mapUser(_auth.currentUser)!;
  }

  @override
  Future<AppUser> signInWithEmailPassword({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return _mapUser(cred.user)!;
  }

  @override
  Future<AppUser> registerWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if ((displayName ?? '').trim().isNotEmpty) {
      await cred.user!.updateDisplayName(displayName!.trim());
    }
    return _mapUser(_auth.currentUser)!;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = fa.GoogleAuthProvider();
      final cred = await _auth.signInWithPopup(provider);
      return _mapUser(cred.user)!;
    } else {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Login Google dibatalkan');
      }
      final googleAuth = await googleUser.authentication;
      final credential = fa.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      return _mapUser(cred.user)!;
    }
  }

  @override
  Future<String> requestPhoneVerification(String phoneNumber) async {
    if (kIsWeb) {
      try {
        final result = await _auth.signInWithPhoneNumber(phoneNumber);
        _webConfirmationResult = result;
        return result.verificationId;
      } catch (e) {
        throw Exception('Gagal mengirim OTP: $e');
      }
    } else {
      final completer = Completer<String>();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (fa.PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            if (!completer.isCompleted) {
              completer.complete('');
            }
          } catch (e) {
            if (!completer.isCompleted) {
              completer.completeError(e);
            }
          }
        },
        verificationFailed: (fa.FirebaseAuthException e) {
          if (!completer.isCompleted) {
            completer.completeError(Exception(e.message ?? 'Verifikasi gagal'));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
      );
      return completer.future;
    }
  }

  @override
  Future<AppUser> verifySmsCode({required String verificationId, required String smsCode}) async {
    if (kIsWeb && _webConfirmationResult != null) {
      final cred = await _webConfirmationResult!.confirm(smsCode);
      return _mapUser(cred.user)!;
    }

    final credential = fa.PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    final cred = await _auth.signInWithCredential(credential);
    return _mapUser(cred.user)!;
  }

  @override
  Future<void> signOut() async {
    _webConfirmationResult = null;
    await _auth.signOut();
  }

  @override
  Future<void> linkEmailPassword({required String email, required String password}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Tidak ada pengguna yang sedang masuk');
    }
    final credential = fa.EmailAuthProvider.credential(email: email, password: password);
    await user.linkWithCredential(credential);
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Tidak ada pengguna yang sedang masuk');
    }
    await user.updateDisplayName(displayName);
  }
}