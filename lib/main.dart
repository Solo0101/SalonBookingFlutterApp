import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Constants/router_constants.dart';
import 'package:test_project/Shared/router.dart';
import 'package:test_project/contents_page.dart';
import 'dart:async';

import 'managers/database_manager.dart';

SharedPreferences themePrefs = SharedPreferences as SharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent));
  themePrefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  deletePastAppointmentsFromDb();

  Timer.periodic(const Duration(minutes: 31), (Timer timer) {
    deletePastAppointmentsFromDb();
    print("Deleted past appointments from Database!");
  });

  runApp(const ProviderScope(child: MyApp()));
}



final navigatorKey = GlobalKey<NavigatorState>();

final ValueNotifier<ThemeMode> themeNotifier = themePrefs.getBool("isDarkTheme") != null ?
(themePrefs.getBool("isDarkTheme")! ? ValueNotifier(ThemeMode.dark) : ValueNotifier(ThemeMode.light))
: ValueNotifier(ThemeMode.dark);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            home: const MyHomePage(),
            theme: ThemeData(primarySwatch: Colors.green),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        });
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A)));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong!'));
              } else if (snapshot.hasData) {
                return const MainPage();
              } else {
                return const LoginOrRegisterView();
              }
            }));
  }
}

class LoginOrRegisterView extends StatelessWidget {
  const LoginOrRegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome back!'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(160, 70),
                ),
                child: const Text(
                  'Log In!',
                  style: TextStyle(fontSize: 23),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(loginViewRoute);
                },
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(160, 70),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 23),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(registerViewRoute);
                },
              ),
            ),
          ],
        ));
  }
}
