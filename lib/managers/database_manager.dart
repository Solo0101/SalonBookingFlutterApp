import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

final databaseRef = FirebaseDatabase.instance.ref();

class Appointment {
  late String barbershopName;
  late String userId;
  late String address;
  late DateTime bookingTime;
  late DateTime bookingEndTime;

  Appointment({
    required this.barbershopName,
    required this.userId,
    required this.bookingTime,
    required this.bookingEndTime,
    required this.address
  });
}

Future<void> insertData(String userId, String barbershopName, String address, DateTime bookingTime, DateTime bookingEndTime) async {
  final appointmentId = const Uuid().v5(Uuid.NAMESPACE_URL, barbershopName + bookingTime.millisecondsSinceEpoch.toString());
  //if(appointmentId) {
  try {
    await databaseRef.child(appointmentId).set({
      'userId': userId,
      'barbershopName': barbershopName,
      'address': address,
      'bookingTime': bookingTime.millisecondsSinceEpoch,
      'bookingEndTime': bookingEndTime.millisecondsSinceEpoch
    });
    print("Added to database");
  } catch (e) {
    print("Error! $e");
  }
  //}
}

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

Future<List<DateTimeRange>> getBarbershopAppointmentsData (String barbershopName, List<DateTimeRange> converted) async{
  await databaseRef.get().then((snapshot) {
    if(snapshot.value != null) {
      final Map data = snapshot.value as Map;
      data.forEach((i, value) {
        if (value['barbershopName'] == barbershopName) {
          converted.add(DateTimeRange(
              start: DateTime.fromMillisecondsSinceEpoch(value['bookingTime']),
              end: DateTime.fromMillisecondsSinceEpoch(value['bookingEndTime'])
          ));
        }
      });
    }});
  return converted;
}

Future<List<Appointment>> getUserAppointmentsData () async{
  final user = FirebaseAuth.instance.currentUser!;
  List<Appointment> myAppointments = [];
  await databaseRef.get().then((snapshot) {
    if(snapshot.value != null) {
      final Map data = snapshot.value as Map;
      data.forEach((i, value) {
        if (value['userId'] == user.uid) {
          Appointment aux = Appointment(
              barbershopName: value['barbershopName'],
              userId: value['userId'],
              address: value['address'],
              bookingTime: DateTime.fromMillisecondsSinceEpoch(
                  value['bookingTime']),
              bookingEndTime: DateTime.fromMillisecondsSinceEpoch(
                  value['bookingEndTime'])
          );
          myAppointments.add(aux);
        }
      });
    }});
  return myAppointments;
}


