import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../constants/app_urls.dart';
import 'database_manager.dart';
import 'package:http/http.dart' as http;

DatabaseReference barbershopsDbRef = FirebaseDatabase.instance.ref("barbershops");

class Barbershop {
  late String id;
  late String name;
  late String gender;
  late String address;
  late String description;
  late String phoneNumber;
  late String image;

  Barbershop({
    required this.id,
    required this.name,
    this.gender='any',
    required this.address,
    this.description='',
    required this.phoneNumber,
    required this.image
  });


  factory Barbershop.fromJson(Map<String, dynamic> json, String key) {
    return Barbershop(
      id: key,
      name: json['name'] as String,
      gender: json['gender'] as String,
      address: json['address'] as String,
      description: json['description'] as String,
      phoneNumber: json['phoneNumber'] as String,
      image: json['image'] as String
    );
  }
}

List<Barbershop> parseBarbershops(String responseBody){
  final Map<String, dynamic> parsed = jsonDecode(responseBody);
  List<Barbershop> barbershopsData = [];
  for (var key in parsed.keys) {
    barbershopsData.add(Barbershop.fromJson(parsed[key], key));
  }
  return barbershopsData;
}

Future getBarbershops() async {
  Uri url = Uri.parse(AppUrls.barbershopListURL);
  var response = await http.get(url);
  if(response.statusCode == 200){
    return parseBarbershops(response.body);
  } else {
    throw Exception('Unable to fetch data from te REST API!');
  }
}
