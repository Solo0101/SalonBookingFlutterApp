import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_project/constants/router_constants.dart';
import 'package:test_project/managers/provider_manager.dart';
import 'package:test_project/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'managers/database_manager.dart';

class CardTemplate extends ConsumerStatefulWidget {
  const CardTemplate({
      Key? key,
      required this.pressed,
      required this.id,
      required this.name,
      required this.address,
      required this.description,
      required this.presentationImage,
      required this.phoneNumber,
      required this.index
  }): super(key: key);

  final List<bool> pressed;
  final String id;
  final String name;
  final String address;
  final String description;
  final String presentationImage;
  final String phoneNumber;
  final int index;

  @override
  ConsumerState<CardTemplate> createState() => _CardTemplateState();
}


class _CardTemplateState extends ConsumerState<CardTemplate> {

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
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 15)),
            ListTile(
              leading: Visibility(
                visible: widget.description != '',
                child: IconButton(
                  onPressed: () => setState(() => widget.pressed[widget.index] =
                      !widget.pressed[widget.index]),
                  icon: Icon(widget.pressed[widget.index]
                      ? Icons.arrow_drop_up_sharp
                      : Icons.arrow_drop_down_sharp),
                ),
              ),
              title: Text(widget.name),
              subtitle: TextButton(
                  onPressed: () => MapsLauncher.launchQuery(widget.address),
                  child: Text(
                        widget.address,
                        style: const TextStyle(color: Colors.grey),
                      ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Visibility(
                  visible: widget.pressed[widget.index],
                  replacement: const SizedBox.shrink(),
                  child: Text(widget.description,
                      style: const TextStyle(color: Colors.grey)),
                )),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () async {
                    ref.read(currentBarbershopProvider.notifier).state = widget.name;
                    ref.read(currentAddressProvider.notifier).state = widget.address;
                    LoadingIndicatorDialog().show(context);
                    List<DateTimeRange> converted = [];
                    await getBarbershopAppointmentsData(widget.name, converted);
                    ref.read(currentBookedHoursProvider.notifier).state = converted;
                    LoadingIndicatorDialog().dismiss();
                    Navigator.of(context).pushNamed(appointmentSelectionPageRoute);
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
