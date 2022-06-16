import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_project/managers/settings_manager.dart';

final currentBarbershopProvider = StateProvider((ref) => "");
final currentAddressProvider = StateProvider((ref) => "");
final currentBookedHoursProvider = StateProvider((ref) => List<DateTimeRange>.empty(growable: true));

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
