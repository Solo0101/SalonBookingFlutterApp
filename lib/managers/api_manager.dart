import 'dart:async';
import 'dart:convert';

import '../constants/app_urls.dart';
import 'package:http/http.dart' as http;


class Address {
  late String streetAddress;
  late String numberAddress;
  late String city;

  Address({
    required this.streetAddress,
    required this.numberAddress,
    required this.city
  });
}

class Barbershop {
  late int id;
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

  factory Barbershop.fromJson(Map<String, dynamic> json) {
    return Barbershop(
      id: json['id'] as int,
      name: json['Name'] as String,
      gender: json['gender'] as String,
      address: json['address'] as String,
      description: json['description'] as String,
      phoneNumber: json['phoneNumber'] as String,
      image: json['image'] as String
    );
  }
}

List<Barbershop> parseBarbershops(String responseBody){
  final parsed = jsonDecode(responseBody)['results'].cast<Map<String, dynamic>>();
  return parsed.map<Barbershop>((json) => Barbershop.fromJson(json)).toList();
}

Future<List<Barbershop>> getBarbershops() async {
  Uri url = Uri.parse(AppUrls.barbershopListURL);
  var response = await http.get(url);
  if(response.statusCode == 200){
    return parseBarbershops(response.body);
  }
  return [];
}
