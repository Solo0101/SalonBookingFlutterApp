import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_project/card_template.dart';
import 'package:test_project/managers/api_manager.dart';
import 'constants/router_constants.dart';
import 'managers/authentication_manager.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(
        future: getBarbershops(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<Barbershop> barbershops = snapshot.data;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: barbershops.length,
              itemBuilder: (context, index) {
                var item = barbershops[index];
                List<bool> pressed = List.filled(barbershops.length, false, growable: false);
                return Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: CardTemplate(
                      pressed: pressed,
                      id: item.id,
                      name: item.name,
                      address: item.address,
                      description: item.description,
                      presentationImage: item.image,
                      phoneNumber: item.phoneNumber,
                    ));
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A)));
          }
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
                      return const CircularProgressIndicator(color: Color(0xFF1AB00A));
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
              title: const Text('My Appointments'),
              onTap: () {
                Navigator.of(context).pushNamed(myAppointmentsPageRoute);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pushNamed(settingsPageRoute);
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
