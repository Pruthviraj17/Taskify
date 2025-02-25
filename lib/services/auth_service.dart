import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
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

  Future<User> signUpWithEmailPassword(
      {required String email, required String password}) async {
    // signUp with email and passsword
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // extract user details
    debugPrint(result.toString());
    final User user = result.user!;

    // return user details
    return user;
  }

  Future<User> signInWithEmailPassword(
      {required String email, required String password}) async {
    // signin with email and passsword
    UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    // extract user details
    debugPrint(result.toString());
    final User user = result.user!;

    // return user details
    return user;
  }

  Future<void> signOut() async {
    // Sign out from Google
    await GoogleSignIn().signOut();
    // Sign out from Firebase Auth
    await FirebaseAuth.instance.signOut();
  }
}
