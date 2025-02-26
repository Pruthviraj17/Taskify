import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/models/auth_result.dart';

class AuthService {
  Future<UserCredential> signInWithGoogle() async {
    // begin interactive signin process
    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await guser!.authentication;

    // create a new creadential for user
    final credentials = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }

  Future<AuthResult> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      return AuthResult(user: result.user);
    } on FirebaseAuthException catch (e) {
      String errorMsg;
      switch (e.code) {
        case 'email-already-in-use':
          errorMsg =
              "This email is already in use. Please use a different email.";
          break;
        case 'invalid-email':
          errorMsg = "The email address is badly formatted.";
          break;
        case 'weak-password':
          errorMsg =
              "The password is too weak. Please use a stronger password.";
          break;
        default:
          errorMsg = "Something went wrong! Please try again later.";
          break;
      }

      return AuthResult(errorMessage: errorMsg);
    } catch (e) {
      debugPrint("Unexpected error: $e");
      return AuthResult(
          errorMessage: "Something went wrong! Please try again later.");
    }
  }

  Future<AuthResult> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return AuthResult(user: result.user);
    } on FirebaseAuthException catch (e) {
      String errorMsg;
      print(e.code);
      switch (e.code) {
        case 'invalid-credential':
          errorMsg = "Please enter valid email or password.";
          break;
        case 'wrong-password':
          errorMsg = "Wrong password provided for that user.";
          break;
        case 'invalid-email':
          errorMsg = "The email address is badly formatted.";
          break;
        case 'user-disabled':
          errorMsg = "This user has been disabled.";
          break;
        default:
          errorMsg = "Something went wrong! please try again later.";
          break;
      }

      return AuthResult(errorMessage: errorMsg);
    } catch (e) {
      debugPrint("Unexpected error: $e");
      return AuthResult(
          errorMessage: "Something went wrong! please try again later.");
    }
  }

  Future<void> signOut() async {
    // Sign out from Google
    await GoogleSignIn().signOut();
    // Sign out from Firebase Auth
    await FirebaseAuth.instance.signOut();
  }
}
