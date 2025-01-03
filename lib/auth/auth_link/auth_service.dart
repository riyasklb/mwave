import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<String> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      return 'Verification email sent!';
    } catch (e) {
      log(e.toString());
      return 'Failed to send verification email. Please try again.';
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }


  Future<String> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Login successful!';
    } catch (e) {
      log("Something went wrong");
      return 'Failed to login. Please check your credentials.';
    }
  }

  Future<String> signout() async {
    try {
      await _auth.signOut();
      return 'Successfully signed out!';
    } catch (e) {
      log("Something went wrong");
      return 'Failed to sign out. Please try again.';
    }
  }
}
