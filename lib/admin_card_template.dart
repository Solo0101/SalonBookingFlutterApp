import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_project/admin_dashboard.dart';

import 'managers/database_manager.dart';

class AdminCardTemplate extends ConsumerStatefulWidget {
  const AdminCardTemplate({
    Key? key,
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.presentationImage,
    required this.phoneNumber,
  }): super(key: key);

  final String id;
  final String name;
  final String address;
  final String description;
  final String presentationImage;
  final String phoneNumber;

  @override
  ConsumerState<AdminCardTemplate> createState() => _AdminCardTemplateState();
}

class _AdminCardTemplateState extends ConsumerState<AdminCardTemplate> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Flexible(
              flex: 6,
              child: ListTile(
                title: Text(widget.name),
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 35,
                  child: ElevatedButton(
                    onPressed: () => setState(() {

                    }),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: const Icon( Icons.edit ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 35,
                  child: ElevatedButton(
                    onPressed: () async {
                      int code = await deleteBarbershop(widget.id);
                      String snackbarText = '';
                      if(code == 1) {
                        snackbarText = 'Barbershop successfully removed!';
                      } else {
                        snackbarText = 'Error! Could not remove barbershop!';
                      }
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation1, animation2) =>
                            const AdminDashboardPage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          )
                      );
                      var snackBar = SnackBar(
                        content: Text(snackbarText),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: const Icon( Icons.delete_forever ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
