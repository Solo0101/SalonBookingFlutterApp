import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    Key? key,
    required this.userId,
    required this.barbershopName,
    required this.address,
    required this.bookingTime
  }) : super(key: key);

  final String userId;
  final String barbershopName;
  final String address;
  final DateTime bookingTime;

  @override
  Widget build(BuildContext context) {
    return Card(
        child:Container(
          height: 100,
          color: Colors.grey[700],
          child: Row(
            children: [
              Expanded(
                child:Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ListTile(
                          title: Text(barbershopName),
                          subtitle: Text(address),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child:Text("DATE: " + (bookingTime.day >= 10 ? bookingTime.day.toString() : "0" + bookingTime.day.toString()) + "." + (bookingTime.month >= 10 ? bookingTime.month.toString() : "0" + bookingTime.month.toString())+ "." + bookingTime.year.toString()),
                              onPressed: ()
                              {},
                            ),
                            const SizedBox(width: 8,),
                            TextButton(
                              child: Text("HOUR: " + bookingTime.hour.toString() + ":" + (bookingTime.minute >= 10 ? bookingTime.minute.toString() : "0" + bookingTime.minute.toString())),
                              onPressed: (){},
                            ),
                            const SizedBox(width: 8,)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                flex:8 ,
              ),
            ],
          ),
        ),
        elevation: 8,
        margin: EdgeInsets.all(10),
      );
  }
}