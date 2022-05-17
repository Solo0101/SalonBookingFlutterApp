import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_project/Shared/router-constants.dart';
import 'package:test_project/managers/authentication_manager.dart';

//import 'package:provider/provider.dart';

class CredentialView extends StatefulWidget {
  final String screenTitle;
  final String buttonTitle;
  final bool isSignUpScreen;
  late final Color _textColor;

  CredentialView({
    Key? key,
    required this.screenTitle,
    required this.buttonTitle,
    required this.isSignUpScreen,
  }) : super(key: key) {
    _textColor = isSignUpScreen ? Colors.grey : Colors.white;
  }

  @override
  _LoginOrSignUpScreen createState() => _LoginOrSignUpScreen();
}

class _LoginOrSignUpScreen extends State<CredentialView> {
  String _email="";
  String _password="";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.screenTitle,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        if(!widget.isSignUpScreen) setSubtitlesForLogInView(),
        const SizedBox(height: 45),
        const Text(
            'Email',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        TextField(
          onChanged: (newValue){
            _email=newValue;
          },
        ),
        const SizedBox(height: 45),
        const Text(
          'Password',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        TextField(
          //obscureText: true,
          onChanged: (newValue){
            _password=newValue;
          },
        ),
        const SizedBox(height: 50),
        TextButton(
          onPressed: () async {
           /* context.read<AuthenticationManager>().logInUser(
                email: emailController.text.trim(),
                password: passwordController.text.trim()
            ); */
            bool isValid = await validateFields(_email, _password);
            print(isValid);
            SnackBar snackBar = SnackBar(content: Text(snackText));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            if(isValid == true) {

              Navigator.of(context).pushNamed(MainPageRoute);
            }
        },
          child: Text(
            widget.buttonTitle,
            style: const TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            fixedSize: const Size.fromHeight(10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
            ),
          )
        ),
        SizedBox(height: widget.isSignUpScreen ? 20.0 : 8.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isSignUpScreen
                  ? "Connect with social!"
                  : "Don't have an account?",
              style: TextStyle(
                color: widget._textColor,
                fontWeight: FontWeight.w500,
              ),
            textAlign: TextAlign.end,
            ),
            if(!widget.isSignUpScreen)
              TextButton(
                  onPressed: () {
                   Navigator.of(context).pushNamed(RegisterViewRoute);
                  },
                child: const Text(
                  "Sign Up!",
                  style: TextStyle(color: Colors.green)
                ),
              ),
          ],
        ),
      ],
    );
  }
  Future<bool> authenticateUser(String email, String password){
    AuthenticationManager authenticationManager = AuthenticationManager();
    if(widget.isSignUpScreen){
      return (authenticationManager.signUpUser(email, password));
    }else{
      return (authenticationManager.logInUser(email, password));
    }
  }

  Future<bool> validateFields(String email, String password){
    if(_email.isNotEmpty && _password.isNotEmpty){
      return authenticateUser(email, password);
    }else{
    //if(_email.isEmpty || _password.isEmpty){
      SnackBar snackBar = const SnackBar(content: Text("Email and password required!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    }
   //return false;
  }
}

Widget setSubtitlesForLogInView() {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        SizedBox(height: 20),
        Center(child: Text('Enter your email and password!')),
  ]);
}


