import 'package:flutter/material.dart';
import 'package:test_project/Shared/router-constants.dart';
import 'package:test_project/contents_page.dart';
import 'package:test_project/main.dart';
import '../register_page.dart';
import '../login_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case HomeViewRoute:
        return MaterialPageRoute(builder: (_) => const MyHomePage(title: 'My home page!'));
      case LoginViewRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage(title: 'Login Page'));
      case RegisterViewRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPage(title: 'Register Page'));
      case MainPageRoute:
        return MaterialPageRoute(builder: (_) => const MainPage(title: 'Main Page'));
        ///Add new cases with routes HERE!!!!!!!
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error 404!'),
        ),
      );
    });
  }
}
