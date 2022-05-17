import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/Shared/router-constants.dart';
import 'package:test_project/Shared/router.dart';
import 'package:test_project/contents_page.dart';

//import 'managers/authentication_manager.dart';

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	runApp(const MyApp());
	await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
				title: 'Home Page',
				theme: ThemeData.dark(
		),
		initialRoute: HomeViewRoute,
		onGenerateRoute:  RouteGenerator.generateRoute,

			/*MultiProvider(
			providers: [
				Provider<AuthenticationManager?>(
						create: (_) => AuthenticationManager(FirebaseAuth.instance),
				),
				StreamProvider(create: (context) => context.read<AuthenticationManager?>()?.authStateChanges, initialData: null,),
			],
			child: MaterialApp(
				title: 'Home Page',
				theme: ThemeData.dark(
				),
				home: const AuthenticationWrapper(),
				onGenerateRoute:  RouteGenerator.generateRoute,
			),*/
		);
	}
}

class MyHomePage extends StatefulWidget {
	const MyHomePage({Key? key, required this.title}) : super(key: key);

	final String title;

	@override
	State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Welcome back!'),
			),
			body: Column(
				crossAxisAlignment: CrossAxisAlignment.center,
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
						Center(
							child: ElevatedButton(
								style:ElevatedButton.styleFrom(
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
									Navigator.of(context).pushNamed(LoginViewRoute);
								},
							),
						),
					 const SizedBox(height: 30),
					 Center(
						 child: ElevatedButton(
							style:ElevatedButton.styleFrom(
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
								Navigator.of(context).pushNamed(RegisterViewRoute);
							},
						 ),
					 ),
				],
			),
		);
	}
}

class AuthenticationWrapper extends StatelessWidget {
	const AuthenticationWrapper({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		final firebaseUser = context.watch<User?>();

		if(firebaseUser != null){
			return const MainPage(title: 'Main Page');
		}else{
			return const MyHomePage(title: "My Home page");
		}
	}
}
