import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

String snackText='';

class AuthenticationManager {

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> logInUser(String email, String password) async {

    try {
      var credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(credential.user != null && credential.user!.email != null) {
        saveUserData(credential.user!.email!);
      }
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
      var credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(credential.user != null && credential.user!.email != null) {
        saveUserData(credential.user!.email!);
      }
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

  void saveUserData(String email) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('userEmail', email);
  }

  bool isLoggedIn(SharedPreferences sharedPrefs){
    return sharedPrefs.getString('userEmail') != null;
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
  } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
