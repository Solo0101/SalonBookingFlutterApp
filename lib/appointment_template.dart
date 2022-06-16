import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

//import 'package:test_project/constants/router_constants.dart';
import 'package:test_project/my_appointments_page.dart';
//import 'package:test_project/splash_screen.dart';

import 'main.dart';
import 'managers/database_manager.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    Key? key,
    required this.appointmentId,
    required this.userId,
    required this.barbershopName,
    required this.address,
    required this.bookingTime,
    required this.appointmentsList,
    required this.appointmentCurrentIndex,
  }) : super(key: key);

  final String appointmentId;
  final String userId;
  final String barbershopName;
  final String address;
  final DateTime bookingTime;
  final List<Appointment> appointmentsList;
  final int appointmentCurrentIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => MapsLauncher.launchQuery(address),
      child: Card(
        child: Container(
          height: 100,
          color: themeNotifier.value == ThemeMode.light ? Colors.grey[200] : Colors.grey[700],
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ListTile(
                          title: Text(barbershopName),
                          subtitle: Text(address),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(("DATE: " +
                                  (bookingTime.day >= 10
                                      ? bookingTime.day.toString()
                                      : "0" + bookingTime.day.toString()) +
                                  "." +
                                  (bookingTime.month >= 10
                                      ? bookingTime.month.toString()
                                      : "0" + bookingTime.month.toString()) +
                                  "." +
                                  bookingTime.year.toString()) +
                                  ("\nHOUR: " +
                                      bookingTime.hour.toString() +
                                      ":" +
                                      (bookingTime.minute >= 10
                                          ? bookingTime.minute.toString()
                                          : "0" +
                                          bookingTime.minute.toString()))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                                  //shape: ,
                                ),
                                child: const Text("CANCEL",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  /* LoadingIndicatorDialog().show(context);*/
                                  deleteAppointmentsWithId(appointmentId);
                                  /* LoadingIndicatorDialog().dismiss();*/
                                  appointmentsList
                                      .removeAt(appointmentCurrentIndex);
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                      const MyAppointmentsPage(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                flex: 8,
              ),
            ],
          ),
        ),
        elevation: 8,
        margin: const EdgeInsets.all(10),
      )
    );
  }
}
