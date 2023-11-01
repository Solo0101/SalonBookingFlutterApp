import 'package:flutter/material.dart';
import 'package:test_project/admin_card_template.dart';

import 'main.dart';
import 'managers/api_manager.dart';
import 'managers/database_manager.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool pressAdd = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  ///TODO: transform to loading an image from files
  final TextEditingController imageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
        ),
        body: ListView(
            padding: const EdgeInsets.all(15),
            children: [
                const Center(
                  child: Text("Edit Barbershops:")
                ),
                Center(
                  child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () => setState(() {
                        pressAdd = !pressAdd;
                        nameController.clear();
                        genderController.clear();
                        addressController.clear();
                        descriptionController.clear();
                        phoneNumberController.clear();
                        imageController.clear();
                      }),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        backgroundColor: !pressAdd ?
                        MaterialStateProperty.all<Color>(Colors.green) : MaterialStateProperty.all<Color>(Colors.red),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: Icon( !pressAdd ? Icons.add : Icons.close),
                    ),
                  )
                ),
                Visibility(
                    visible: pressAdd,
                    child: Center(
                      child: Card(
                          elevation: 5,
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                                children: [
                                  const Padding(padding: EdgeInsets.only(top: 15)),
                                  const Text("Create new Barbershop: "),
                                  TextField(
                                    controller: nameController,
                                    cursorColor: themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(labelText: 'Name*'),
                                  ),
                                  TextField(
                                    controller: genderController,
                                    cursorColor: themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(labelText: 'Gender (Default "any")'),
                                  ),
                                  TextField(
                                    controller: addressController,
                                    cursorColor: themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(labelText: 'Address*'),
                                  ),
                                  TextField(
                                    controller: descriptionController,
                                    cursorColor: themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(labelText: 'Description'),
                                  ),
                                  TextField(
                                    controller: phoneNumberController,
                                    cursorColor: themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(labelText: 'Tel.*'),
                                  ),
                                  TextField(
                                    controller: imageController,
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
                                            switch(await insertBarbershop(
                                              nameController.text.trim(),
                                              addressController.text.trim(),
                                              genderController.text.trim(),
                                              descriptionController.text.trim(),
                                              phoneNumberController.text.trim(),
                                              imageController.text.trim(),
                                            )) {
                                              case 0:
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                setState(() => pressAdd = !pressAdd);
                                                nameController.clear();
                                                genderController.clear();
                                                addressController.clear();
                                                descriptionController.clear();
                                                phoneNumberController.clear();
                                                imageController.clear();
                                                snackbarText = 'Barbershop added!';
                                                break;
                                              case 1:
                                                snackbarText = 'All fields with ending with "*" must be completed!';
                                                break;
                                              case 2:
                                                snackbarText = 'An error has occured with adding the barbershop!';
                                                break;
                                            }
                                            var snackBar = SnackBar(
                                              content: Text(snackbarText),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                        child: const Text("Create"),
                                      ),
                                    ),
                                  )
                                ]),
                          )
                          )
                    )
                ),
                FutureBuilder(
                  future: getBarbershops(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      List<Barbershop> barbershops = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: barbershops.length,
                        itemBuilder: (context, index) {
                          var item = barbershops[index];
                          return Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: AdminCardTemplate(
                              id: item.id,
                              name: item.name,
                              address: item.address,
                              description: item.description,
                              presentationImage: item.image,
                              phoneNumber: item.phoneNumber,
                              )
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A)));
                    }
                  },
                ),

    ])
    );
  }
}
