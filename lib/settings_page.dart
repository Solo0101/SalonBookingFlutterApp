import 'package:flutter/material.dart';

import 'main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
          const Text("Select Theme: "),
          Switch(
              value: themeNotifier.value == ThemeMode.dark,
              onChanged: (value) {
                setState(() {
                  themeNotifier.value = themeNotifier.value == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                });
              },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
          Icon(themeNotifier.value == ThemeMode.light
                  ? Icons.light_mode
                  : Icons.dark_mode
          ),
        ])
    );
  }
}
