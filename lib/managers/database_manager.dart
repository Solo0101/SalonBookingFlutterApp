import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

final databaseRef = FirebaseDatabase.instance.ref();

class Appointment {
  late String barberShopName;
  late String userId;
  late int bookingTime;
  late int bookingEndTime;

  Appointment({
    required this.barberShopName,
    required this.userId,
    required this.bookingTime,
    required this.bookingEndTime
  });

 /* Appointment.fromSnapshot(DataSnapshot snapshot){
        barberShopName = snapshot.value['barberShopName'];
        userId = snapshot.value['userId'];
        bookingTime = snapshot.value['bookingTime'];
        bookingEndTime = snapshot.value['bookingEndTime'];
  }*/

  /*Appointment.fromJson() {

  }*/

}

/*

Future<List<Appointment>> getAppointments() async{
  Completer<List<Appointment>> completer = Completer<List<Appointment>>();

  List<Appointment> appointments = [];

  databaseRef.get().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> appointmentMap = snapshot.value as Map;
    appointmentMap.forEach((key, value) {
      appointments.add(Appointment.fromJson());
    });
    completer.complete(appointments);
});
  return completer.future;
}
*/

Future<void> deletePastAppointmentsFromDb() async{
  databaseRef.get().then((snapshot) {
    final Map data = snapshot.value as Map;
    data.forEach((i, value) {
      if(DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(value['bookingEndTime']))){
        databaseRef.child(i).remove();
      }
    });
  });

}