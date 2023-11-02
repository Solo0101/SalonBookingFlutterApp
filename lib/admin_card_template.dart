import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_project/admin_dashboard.dart';

import 'main.dart';
import 'managers/database_manager.dart';

class AdminCardTemplate extends ConsumerStatefulWidget {
  const AdminCardTemplate({
    Key? key,
    required this.id,
    required this.name,
    required this.address,
    required this.gender,
    required this.description,
    required this.presentationImage,
    required this.phoneNumber,
  }): super(key: key);

  final String id;
  final String name;
  final String address;
  final String gender;
  final String description;
  final String phoneNumber;
  final String presentationImage;

  ///TODO: delete if useless
  String getName() => name;
  String getAddress() => address;
  String getGender() => gender;
  String getDescription() => description;
  String getPhoneNumber() => phoneNumber;
  String getPresentationImage() => presentationImage;

  @override
  ConsumerState<AdminCardTemplate> createState() => _AdminCardTemplateState();
}

class _AdminCardTemplateState extends ConsumerState<AdminCardTemplate> {

  bool pressEdit = false;
  late TextEditingController nameController;
  late TextEditingController genderController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;
  late TextEditingController phoneNumberController;

  ///TODO: transform to loading an image from files
  TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Row(
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
                            pressEdit=!pressEdit;
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
                          if (context.mounted) {
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
                          }
                          var snackBar = SnackBar(
                            content: Text(snackbarText),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
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
            Visibility(
                visible: pressEdit,
                child: Center(
                    child: Card(
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                              children: [
                                const Padding(padding: EdgeInsets.only(top: 15)),
                                const Text("Edit: "),
                                TextField(
                                  controller: nameController = TextEditingController(text: widget.name),
                                  cursorColor: themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(labelText: 'Name*'),
                                ),
                                TextField(
                                  controller: genderController = TextEditingController(text: widget.gender),
                                  cursorColor: themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(labelText: 'Gender (Default "any")'),
                                ),
                                TextField(
                                  controller: addressController = TextEditingController(text: widget.address),
                                  cursorColor: themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(labelText: 'Address*'),
                                ),
                                TextField(
                                  controller: descriptionController = TextEditingController(text: widget.description),
                                  cursorColor: themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(labelText: 'Description'),
                                ),
                                TextField(
                                  controller: phoneNumberController = TextEditingController(text: widget.phoneNumber),
                                  cursorColor: themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(labelText: 'Tel.*'),
                                ),
                                TextField(
                                  controller: imageController = TextEditingController(text: widget.presentationImage),
                                  cursorColor: themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(labelText: 'Image link*'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        String snackbarText = '';
                                        switch(await editBarbershop(
                                          widget.id,
                                          nameController.text.trim(),
                                          addressController.text.trim(),
                                          genderController.text.trim(),
                                          descriptionController.text.trim(),
                                          phoneNumberController.text.trim(),
                                          imageController.text.trim(),
                                        )) {
                                          case 0:
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            setState(() => pressEdit = !pressEdit);
                                            nameController.clear();
                                            genderController.clear();
                                            addressController.clear();
                                            descriptionController.clear();
                                            phoneNumberController.clear();
                                            imageController.clear();
                                            snackbarText = 'Barbershop edited successfully!';
                                            break;
                                          case 1:
                                            snackbarText = 'All fields with ending with "*" must be completed!';
                                            break;
                                          case 2:
                                            snackbarText = 'An error has occurred with editing the barbershop!';
                                            break;
                                        }
                                        var snackBar = SnackBar(
                                          content: Text(snackbarText),
                                        );

                                        if (context.mounted) {
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
                                        }

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                      child: const Text("Save"),
                                    ),
                                  ),
                                )
                              ]),
                        )
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}
