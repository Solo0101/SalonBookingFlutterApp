import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_project/managers/provider_manager.dart';

import 'managers/database_manager.dart';

List<DateTimeRange> globalConverted = [];

class AppointmentSelection extends ConsumerStatefulWidget {
  const AppointmentSelection({Key? key}) : super(key: key);

  @override
  ConsumerState<AppointmentSelection> createState() => _AppointmentSelectionState();
}

class _AppointmentSelectionState extends ConsumerState<AppointmentSelection> {

  final now = DateTime.now();
  late BookingService appointmentBookingService;

  final user = FirebaseAuth.instance.currentUser!;
  final databaseRef = FirebaseDatabase.instance.ref();
  late String globalCurrentBarbershopName;

  @override
  void initState(){
    super.initState();

    appointmentBookingService = BookingService(
        userId: user.uid,
        userEmail: user.email,
        serviceName: 'Appointment Service',
        serviceDuration: 30,
        bookingStart: DateTime(now.year, now.month, now.day, 8, 0),
        bookingEnd: DateTime(now.year, now.month, now.day, 18, 0)
    );
  }

  Stream<dynamic>? getBookingStreamAppointment({required DateTime start, required DateTime end}){
    Stream<dynamic> streamToReturn = databaseRef.child("appointments").onValue;
    return streamToReturn;
  }

  Future<dynamic> uploadBookingAppointment({required BookingService newBooking}) async {
    ///database write
    String currentBarbershopName = ref.watch(currentBarbershopProvider);
    String currentBarbershopAddress = ref.watch(currentAddressProvider);
    insertData(user.uid, currentBarbershopName, currentBarbershopAddress, newBooking.bookingStart, newBooking.bookingStart.add(const Duration(minutes: 30)));
    converted.add(DateTimeRange(start: newBooking.bookingStart, end: newBooking.bookingEnd));
    if (kDebugMode) {
      print('${newBooking.toJson()} has been uploaded');
    }
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultAppointment({required dynamic streamResult}) {
    ///database read
    List<DateTimeRange> currentBookedHoursValue = ref.watch(currentBookedHoursProvider);
    converted = currentBookedHoursValue;
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
            loadingWidget: const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A))),
            uploadingWidget: const Center(child: CircularProgressIndicator(color: Color(0xFF1AB00A))),
            wholeDayIsBookedWidget: const Center(child: Text('Sorry, for this day everything is booked!')),
            startingDayOfWeek: StartingDayOfWeek.monday,
            disabledDays: const [7],
            hideBreakTime: true,
            pauseSlots: const [],
          ),
        )
    );
  }



}
