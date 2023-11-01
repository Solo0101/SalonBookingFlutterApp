import 'dart:async';

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


/// Handler functions for appointments

Future<void> insertData(String userId, String barbershopName, String address, DateTime bookingTime, DateTime bookingEndTime) async {
  final appointmentId = const Uuid().v5(Uuid.NAMESPACE_URL, barbershopName + bookingTime.millisecondsSinceEpoch.toString());
  try {
    await databaseRef.child("appointments/$appointmentId").set({
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
}


Future<void> deletePastAppointmentsFromDb() async{
  databaseRef.child("appointments").get().then((snapshot) {
    final Map data = snapshot.value as Map;
    data.forEach((i, value) {
      if(DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(value['bookingEndTime']))){
        databaseRef.child(i).remove();
      }
    });
  });
}

Future<void> deleteAppointmentsWithId(String appointmentId) async{
        databaseRef.child("appointments/$appointmentId").remove();
}

Future<List<DateTimeRange>> getBarbershopAppointmentsData (String barbershopName, List<DateTimeRange> converted) async{
  await databaseRef.child("appointments").get().then((snapshot) {
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

Future<List<Appointment>> getUserAppointmentsData (String userId) async{
  List<Appointment> myAppointments = [];
  await databaseRef.child("appointments").get().then((snapshot) {
    if(snapshot.value != null) {
      final Map data = snapshot.value as Map;
      data.forEach((i, value) {
        if (value['userId'] == userId) {
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

/// Handler functions for Barbershops

Future<int> insertBarbershop(String barbershopName, String address, String gender, String description, String phoneNumber, String image) async {
  final barbershopId = const Uuid().v5(Uuid.NAMESPACE_URL, barbershopName + address);
  try {
    if (barbershopName.isNotEmpty &&
        address.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        image.isNotEmpty){
        if(gender.isEmpty){
          gender = "any";
        }
        await databaseRef.child("barbershops/$barbershopId").set({
          'name': barbershopName,
          'address': address,
          'gender': gender,
          'description': description,
          'phoneNumber': phoneNumber,
          'image': image
        });
      print("Added to database");
      return Future.value(0);
    } else {
      return Future.value(1);
    }
  } catch (e) {
    print("Error! $e");
    return  Future.value(2);
  }
}

Future<int> deleteBarbershop(String barbershopId) async{
  try {
    databaseRef.child("barbershops/$barbershopId").remove();
    return Future.value(1);
  } catch (e) {
    print("Error! $e");
    return Future.value(0);
  }
}

