import 'package:flutter/material.dart';
/*import 'package:provider/provider.dart';
import 'package:test_project/managers/state_manager.dart';*/
import 'package:booking_calendar/booking_calendar.dart';



class AppointmentSelection extends StatefulWidget {
  const AppointmentSelection({Key? key}) : super(key: key);

  @override
  State<AppointmentSelection> createState() => _AppointmentSelectionState();
}

class _AppointmentSelectionState extends State<AppointmentSelection> {

  final now = DateTime.now();
  late BookingService appointmentBookingService;

  @override

  void initState() {
    super.initState();
    //DateTime.now().startOfDay
    // DateTime.now().endOfDay
    appointmentBookingService = BookingService(
        serviceName: 'Appointment Service',
        serviceDuration: 30,
        bookingEnd: DateTime(now.year, now.month, now.day, 20, 0),
        bookingStart: DateTime(now.year, now.month, now.day, now.hour, 0));
  }

  Stream<dynamic>? getBookingStreamAppointment({required DateTime end, required DateTime start}) => Stream.value([]);

  Future<dynamic> uploadBookingAppointment({required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    converted.add(DateTimeRange(start: newBooking.bookingStart, end: newBooking.bookingEnd));
    print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultAppointment({required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    /*DateTime first = now;
    DateTime second = now.add(const Duration(minutes: 55));
    DateTime third = now.subtract(const Duration(minutes: 240));
    DateTime fourth = now.subtract(const Duration(minutes: 500));
    converted.add(DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
    converted.add(DateTimeRange(start: second, end: second.add(const Duration(minutes: 23))));
    converted.add(DateTimeRange(start: third, end: third.add(const Duration(minutes: 15))));
    converted.add(DateTimeRange(start: fourth, end: fourth.add(const Duration(minutes: 50))));*/
    return converted;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Make an appointment'),
      ),
      body: Center(
        child: BookingCalendar(
          bookingService: appointmentBookingService,
          convertStreamResultToDateTimeRanges: convertStreamResultAppointment,
          getBookingStream: getBookingStreamAppointment,
          uploadBooking: uploadBookingAppointment,
          loadingWidget: const CircularProgressIndicator(),

        ),
      )
    );
  }
}
