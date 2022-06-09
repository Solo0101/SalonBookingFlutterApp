import 'package:flutter/material.dart';
import 'package:test_project/Constants/router_constants.dart';
import 'package:test_project/managers/authentication_manager.dart';

import '../Constants/router_constants.dart';

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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;

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
        if (!widget.isSignUpScreen) setSubtitlesForLogInView(),
        const SizedBox(height: 45),
        TextField(
          controller: emailController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 45),
        TextField(
          obscureText: _isObscure,
          controller: passwordController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
          ),
        ),
        const SizedBox(height: 50),
        TextButton(
            onPressed: () async {
              bool isValid = await validateFields(
                  emailController.text.trim(), passwordController.text.trim());
              SnackBar snackBar = SnackBar(content: Text(snackText));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              if (isValid == true) {
                Navigator.of(context).pushNamed(mainPageRoute);
              }
            },
            child: Text(
              widget.buttonTitle,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(115, 60),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(35),
                ),
              ),
            )),
        SizedBox(height: widget.isSignUpScreen ? 20.0 : 8.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isSignUpScreen
                  ? "" //"Connect with social!"
                  : "Don't have an account?",
              style: TextStyle(color: widget._textColor, fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
            if (!widget.isSignUpScreen)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(registerViewRoute);
                },
                child: const Text("Sign Up!",style: TextStyle(color: Colors.green)),
              ),
          ],
        ),
      ],
    );
  }

  Future<bool> authenticateUser(String email, String password) async {
    AuthenticationManager authenticationManager = AuthenticationManager();
    if (widget.isSignUpScreen) {
      return (authenticationManager.signUpUser(email, password, context));
    } else {
      return (authenticationManager.logInUser(email, password, context));
    }
  }

  Future<bool> validateFields(String email, String password) async {
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      return await authenticateUser(email, password);
    } else {
      SnackBar snackBar =
          const SnackBar(content: Text("Email and password required!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    }
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
