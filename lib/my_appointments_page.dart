import 'package:flutter/material.dart';
import 'package:test_project/appointment_template.dart';

import 'managers/database_manager.dart';

class MyAppointments extends StatelessWidget {
  const MyAppointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('My appointments')
      ),
      body: FutureBuilder(
          future: getUserAppointmentsData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<Appointment> myAppointments = snapshot.data;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: myAppointments.length,
                itemBuilder: (context, index) {
                  Appointment item = myAppointments[index];
                  return Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: AppointmentCard(
                          userId: item.userId,
                          barbershopName: item.barbershopName,
                          address: item.address,
                          bookingTime: item.bookingTime,
                      )
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A)));
            }
          },
        ),
    );
  }
}
