import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

String snackText='';

class AuthenticationManager {
  //final FirebaseAuth credential;

  //AuthenticationManager(this.credential);

  //Stream<User?> get authStateChanges => credential.authStateChanges();

  /* Future<void> logInUser({required String email, required String password}) async{
    try {
       await credential.signInWithEmailAndPassword(
          email: email,
          password: password
      );
       print('Signed in!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }

  }
  Future<void> signUpUser({required String email, required String password}) async {
    try {
      await credential.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Signed up!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }*/


  Future<bool> logInUser(String email, String password) async {

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        snackText='No user found for that email.';
        print('No user found for that email.');
        return Future.value(false);
      } else if (e.code == 'invalid-email') {
        snackText='Invalid email.';
        print('Invalid email.');
        return Future.value(false);
      } else if (e.code == 'wrong-password') {
        snackText='Wrong password provided for that user.';
        print('Wrong password provided for that user.');
        return Future.value(false);
      }
    }
    snackText='Logged in!';
    return Future.value(true);
  }

  Future<bool> signUpUser(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackText='Password is to weak.';
        print('Password is to weak.');
        return Future.value(false);
      } else if (e.code == 'email-already-in-use') {
        snackText='The account already exists for that email.';
        print('The account already exists for that email.');
        return Future.value(false);
      }
    } catch (e) {
      print(e);
    }
    snackText='Registered successfully!';
    print('Registered successfully!');
    return Future.value(true);
  }
}
