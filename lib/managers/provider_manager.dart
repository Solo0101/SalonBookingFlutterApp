import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentBarbershopProvider = StateProvider((ref) => "");
final currentAddressProvider = StateProvider((ref) => "");
final currentBookedHoursProvider = StateProvider((ref) => List<DateTimeRange>.empty(growable: true));