import 'package:flutter/material.dart';
import 'package:test_project/appointment_selection_page.dart';
import 'package:test_project/contents_page.dart';
import 'package:test_project/main.dart';
import '../constants/router_constants.dart';
import '../my_appointments_page.dart';
import '../register_page.dart';
import '../login_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case homeViewRoute:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case loginViewRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case registerViewRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case mainPageRoute:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case appointmentSelectionPageRoute:
        return PageRouteBuilder(pageBuilder: (context, animation1, animation2) => const AppointmentSelection(),  transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero);
      case myAppointmentsPageRoute:
        return MaterialPageRoute(builder: (_) => const MyAppointments());
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
