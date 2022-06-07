import 'package:flutter/material.dart';
import 'package:test_project/constants/router_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

class CardTemplate extends StatefulWidget {
  const CardTemplate(
      {Key? key,
      required this.pressed,
      required this.id,
      required this.name,
      required this.address,
      required this.description,
      required this.presentationImage,
      required this.phoneNumber})
      : super(key: key);

  final List<bool> pressed;
  final int id;
  final String name;
  final String address;
  final String description;
  final String presentationImage;
  final String phoneNumber;

  @override
  State<CardTemplate> createState() => _CardTemplateState();
}

class _CardTemplateState extends State<CardTemplate> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: IconButton(
                onPressed: () => setState(() => widget.pressed[widget.id - 1] =
                    !widget.pressed[widget.id - 1]),
                icon: Icon(widget.pressed[widget.id - 1]
                    ? Icons.arrow_drop_up_sharp
                    : Icons.arrow_drop_down_sharp),
              ),
              title: Text(widget.name),
              subtitle: TextButton(
                  onPressed: () => MapsLauncher.launchQuery(widget.address),
                  child: Text(widget.address,
                      style: TextStyle(color: Colors.white.withOpacity(0.6)))),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Visibility(
                  child: Text(widget.description,
                      style: TextStyle(color: Colors.white.withOpacity(0.6))),
                  visible: widget.pressed[widget.id - 1],
                  replacement: const SizedBox.shrink(),
                )),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () => Navigator.of(context).pushNamed(appointmentSelectionPageRoute),
                  child: const Text(
                    'Make an appointment',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),
                    onPressed: () => _makePhoneCall(widget.phoneNumber),
                    child: const Text('Call', style: TextStyle(color: Colors.white)))
              ],
            ),
            Image(
              image: NetworkImage(widget.presentationImage),
            ),
          ],
        ),
      ),
    );
  }
}
