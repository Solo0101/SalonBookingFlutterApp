import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'managers/authentication_manager.dart';

final user = FirebaseAuth.instance.currentUser!;
AuthenticationManager authenticationManager = AuthenticationManager();

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Profile"),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text("E-mail: "), Text(user.email!)],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Change your passowrd: "),
                ],
              ),
              TextField(
                obscureText: _isObscure,
                controller: currentPasswordController,
                cursorColor: themeNotifier.value == ThemeMode.light
                    ? Colors.black
                    : Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
              ),
              TextField(
                obscureText: _isObscure2,
                controller: newPasswordController,
                cursorColor: themeNotifier.value == ThemeMode.light
                    ? Colors.black
                    : Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure2 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _isObscure2 = !_isObscure2),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        //shape: ,
                      ),
                      child: const Text("CHANGE PASSWORD",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        await authenticationManager.changePassword(
                            user.email!,
                            currentPasswordController.text.trim(),
                            newPasswordController.text.trim(),
                            context);
                        SnackBar snackBar = SnackBar(content: Text(snackText));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        currentPasswordController.clear();
                        newPasswordController.clear();
                      }))
            ]),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Wrap(
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        //shape: ,
                      ),
                      child: const Text("DELETE ACCOUNT",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        await authenticationManager.deleteAccount(context);
                        SnackBar snackBar = SnackBar(content: Text(snackText));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                  )
                ],
              ))
        ])));
  }
}
