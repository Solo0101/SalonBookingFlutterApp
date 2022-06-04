import 'package:flutter/material.dart';

class CardTemplate extends StatelessWidget {
  const CardTemplate({Key? key, required this.name, required this.address, required this.description, required this.presentationImage}) : super(key: key);

  final String name;
  final String address;
  final String description;
  final String presentationImage;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 450,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.arrow_drop_down_circle),
              title: Text(name),
              subtitle: Text(address, style: TextStyle(color: Colors.white.withOpacity(0.6))),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(description, style: TextStyle(color: Colors.white.withOpacity(0.6))),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () {
                    // Perform some action
                  },
                  child: const Text(
                    'Make an appointment',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () {
                    // Perform some action
                  },
                  child: const Text(
                    'Call',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Image(
              image: NetworkImage(presentationImage),
          ],
        ),
      ),
    );
  }
}
