import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_project/card_template.dart';
import 'managers/authentication_manager.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  dynamic dummyResponse = "frizerii.json";
  List barbershops = dummyResponse;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: barbershops.length,
        itemBuilder: (context, index) {
          var item = barbershops[index];
          return CardTemplate(
            name: item.name,
            address: item.city + ', ' + item.streetAddress + ', ' + item.numberAddress,
            description: item.description,
            presentationImage:
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black12,
                ),
                child: StreamBuilder<User?>(
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState != ConnectionState.done) {
                      return const CircularProgressIndicator();
                    }
                    return Text(user.email!);
                  },
                )),
            ListTile(
              title: const Text('My Profile'),
              onTap: () {
                print(user.email!);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () async {
                await AuthenticationManager().signOutUser(context);
                SnackBar snackBar = const SnackBar(content: Text('Signed out!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        ),
      ),
    );
  }
}