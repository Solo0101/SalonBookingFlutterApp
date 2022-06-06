import 'package:flutter/material.dart';

class CardTemplate extends StatefulWidget {
  const CardTemplate({Key? key, required this.pressed, required this.id, required this.name, required this.address, required this.description, required this.presentationImage}) : super(key: key);

  final List<bool> pressed;
  final int id;
  final String name;
  final String address;
  final String description;
  final String presentationImage;

  @override
  State<CardTemplate> createState() => _CardTemplateState();
}

class _CardTemplateState extends State<CardTemplate> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: IconButton(
                onPressed: () =>  setState( () => widget.pressed[widget.id-1] = !widget.pressed[widget.id-1]),
                icon:  Icon(widget.pressed[widget.id-1] ? Icons.arrow_drop_up_sharp : Icons.arrow_drop_down_sharp ),
              ),
              title: Text(widget.name),
              subtitle: Text(widget.address, style: TextStyle(color: Colors.white.withOpacity(0.6))),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Visibility(
                  child: Text(widget.description, style: TextStyle(color: Colors.white.withOpacity(0.6))),
                  visible: widget.pressed[widget.id-1],
                  replacement: const SizedBox.shrink(),
                )
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
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
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
              image: NetworkImage(widget.presentationImage),
            ),
          ],
        ),
      ),
    );
  }
}


