import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;

  Future<auth.UserCredential> signInByGoogle();

  Future<bool> sendOTP({required String phone});

  Future<auth.UserCredential> verifyOTP({required String otp});

  Future<bool> checkUserDataExists({required String userId});

  Future<void> logOut();
}
