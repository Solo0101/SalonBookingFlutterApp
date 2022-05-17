import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_project/Shared/router-constants.dart';
//import 'package:test_project/Shared/router-constants.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //var barbershops = popularBarbershops(dummyResponse);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
      body: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_drop_down_circle),
                title: const Text('Barbershop'),
                subtitle: Text(
                  'Timișoara, Str. Piața Victoriei, Nr. 7',
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    style: ButtonStyle(backgroundColor:  MaterialStateProperty.all<Color>(Colors.green)),
                    onPressed: () {
                      // Perform some action
                    },
                    child: const Text('Make an appointment', style: TextStyle(color: Colors.white),),
                  ),
                  TextButton(
                    style: ButtonStyle(backgroundColor:  MaterialStateProperty.all<Color>(Colors.green)),
                    onPressed: () {
                      // Perform some action
                    },
                    child: const Text('Call', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              const Image(
                image: NetworkImage('http://www.agerpres.ro/data/stiri_ots/2019/05/03/pasi-necesari-pentru-a-deschide-un-barbershop.jpg'),
              ),
            ],
          ),
        ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black12,
              ),
              child: const Text('Account Name'),
            ),
            ListTile(
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
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


