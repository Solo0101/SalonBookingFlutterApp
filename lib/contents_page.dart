import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadIsAdmin();
  }

  void _loadIsAdmin() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = (sharedPreferences.getBool("isAdmin"))!;
    });
  }

  Future<void> _refreshBarbershops(BuildContext context) async {
    setState(() => {});
    return getBarbershops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshBarbershops(context),
        child: FutureBuilder(
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
                        index: index,
                      ));
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A)));
            }
          },
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
                child: StreamBuilder<User?>(
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState != ConnectionState.done) {
                      return const CircularProgressIndicator(color: Color(0xFF1AB00A));
                    }
                    return Text(user.email!);
                  }, stream: null,
                )),
            ListTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.manage_accounts,
                    size: 24.0,
                  ),
                  SizedBox(
                    width: 5
                  ),
                  Text('My Profile'),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed(myProfilePageRoute);
              },
            ),
            ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon( _isAdmin ? Icons.addchart_rounded :
                    Icons.calendar_month,
                    size: 24.0,
                  ),
                  const SizedBox(
                      width: 5
                  ),
                  Text( _isAdmin ? 'Admin Dashboard' : 'My Appointments'),
                ],
              ),
              onTap: () {
                if(_isAdmin) {
                  Navigator.of(context).pushNamed(adminDashboardPageRoute);
                } else {
                  Navigator.of(context).pushNamed(myAppointmentsPageRoute);
                }
                },
            ),
            ListTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.settings,
                    size: 24.0,
                  ),
                  SizedBox(
                      width: 5
                  ),
                  Text('Settings'),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed(settingsPageRoute);
              },
            ),
            ListTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.logout,
                    size: 24.0,
                  ),
                  SizedBox(
                      width: 5
                  ),
                  Text('Sign Out'),
                ],
              ),
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
