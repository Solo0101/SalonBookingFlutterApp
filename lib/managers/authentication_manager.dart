import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

String snackText='';

class AuthenticationManager {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> logInUser(String email, String password, var context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A)))
    );

    try {
      var credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(credential.user != null && credential.user?.email != null) {
        saveUserData(credential.user?.email);
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        navigatorKey.currentState!.pop(context);
        snackText='No user found for that email.';
        print('No user found for that email.');
        return Future.value(false);
      } else if (e.code == 'invalid-email') {
        navigatorKey.currentState!.pop(context);
        snackText='Invalid email.';
        print('Invalid email.');
        return Future.value(false);
      } else if (e.code == 'wrong-password') {
        navigatorKey.currentState!.pop(context);
        snackText='Wrong password provided for that user.';
        print('Wrong password provided for that user.');
        return Future.value(false);
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    snackText='Logged in!';
    print('Logged in!');
    return Future.value(true);
  }

  Future<bool> signUpUser(String email, String password, var context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A)))
    );

    try {
      var credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(credential.user != null && credential.user?.email != null) {
        saveUserData(credential.user!.email!);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        navigatorKey.currentState!.pop(context);
        snackText='Password is to weak.';
        print('Password is to weak.');
        return Future.value(false);
      } else if (e.code == 'email-already-in-use') {
        navigatorKey.currentState!.pop(context);
        snackText='The account already exists for that email.';
        print('The account already exists for that email.');
        return Future.value(false);
      }
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    snackText='Registered successfully!';
    print('Registered successfully!');
    return Future.value(true);
  }

  void saveUserData(String? email) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('userEmail', email!);
  }

  bool isLoggedIn(SharedPreferences sharedPrefs){
    var user = sharedPrefs.getString('userEmail');
    print(user);
    return user != null;
  }

  Future<void> signOutUser(var context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A)))
    );
    try{
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      return await _auth.signOut();
  } catch (e) {
      print(e);
    }
  }
}
