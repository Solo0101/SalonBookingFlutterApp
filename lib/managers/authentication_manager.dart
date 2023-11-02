import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

String snackText='';


class AuthenticationManager {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref();

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
      var userId = _auth.currentUser?.uid;
      var admins = await databaseRef.child("admins").child(userId!).once();
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool("isAdmin", false);


      if(admins.snapshot.value != null) {
        sharedPreferences.setBool("isAdmin", true);
        if (kDebugMode) {
          print(sharedPreferences.getBool("isAdmin"));
        }
      } else {
        sharedPreferences.setBool("isAdmin", false);
      }

    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      if (e.code == 'user-not-found') {
        navigatorKey.currentState!.pop(context);
        snackText='No user found for that email.';
        if (kDebugMode) {
          print('No user found for that email.');
        }
        return false;
      } else if (e.code == 'invalid-email') {
        navigatorKey.currentState!.pop(context);
        snackText='Invalid email.';
        if (kDebugMode) {
          print('Invalid email.');
        }
        return false;
      } else if (e.code == 'wrong-password') {
        navigatorKey.currentState!.pop(context);
        snackText='Wrong password provided for that user.';
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
        return false;
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    snackText='Logged in!';
    if (kDebugMode) {
      print('Logged in!');
    }
    return true;
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
        if (kDebugMode) {
          print('Password is to weak.');
        }
        return Future.value(false);
      } else if (e.code == 'email-already-in-use') {
        navigatorKey.currentState!.pop(context);
        snackText='The account already exists for that email.';
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
        return Future.value(false);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    snackText='Registered successfully!';
    if (kDebugMode) {
      print('Registered successfully!');
    }
    return Future.value(true);
  }

  void saveUserData(String? email) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('userEmail', email!);
  }

  Future<void> signOutUser(var context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A)))
    );
    try{
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool("isAdmin", false);
      return await _auth.signOut();
  } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> changePassword(String email, String password, String newPassword, var context) async {
  final user = _auth.currentUser!;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A)))
    );
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        navigatorKey.currentState!.pop(context);
        snackText = 'Wrong password provided for that user.';
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
        return;
      }
    }
    if(password == newPassword){
      navigatorKey.currentState!.pop(context);
      snackText = 'The new password has to be different from the old password!';
      if (kDebugMode) {
        print('The new password has to be different from the old password!');
      }
    }else {
      user.updatePassword(newPassword).then((_) {
        if (kDebugMode) {
          print("Successfully changed password");
        }
      }).catchError((error) {
        if (kDebugMode) {
          print("Password can't be changed$error");
        }
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
      navigatorKey.currentState!.pop(context);
      snackText = 'Password reseted successfully!';
      if (kDebugMode) {
        print('Password reseted successfully!');
      }
    }
  }

  Future<void> deleteAccount(var context) async {
    final user = _auth.currentUser!;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A)))
    );
    try{
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      user.delete();
      signOutUser(context);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    snackText = 'Account successfully deleted!';
    if (kDebugMode) {
      print('Account successfully deleted!');
    }
  }

}

