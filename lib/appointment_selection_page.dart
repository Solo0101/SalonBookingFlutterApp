import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_project/managers/provider_manager.dart';
import 'package:test_project/managers/state_manager.dart';
import 'package:uuid/uuid.dart';

late List<DateTimeRange> globalConverted = [];

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

  void initState() {
    super.initState();

    appointmentBookingService = BookingService(
        userId: user.uid,
        userEmail: user.email,
        serviceName: 'Appointment Service',
        serviceDuration: 30,
        bookingStart: DateTime(now.year, now.month, now.day, 0, 0),
        bookingEnd: DateTime(now.year, now.month, now.day, 0, 0).add(const Duration(minutes: 30))
    );
  }

  Stream<dynamic>? getBookingStreamAppointment({required DateTime end, required DateTime start}) => Stream.value([]);

  Future<dynamic> uploadBookingAppointment({required BookingService newBooking, required currentBarbershopName}) async {
    ///database write
    //print(currentBarbershopName);
    insertData(user.uid, currentBarbershopName, newBooking.bookingStart, newBooking.bookingStart.add(const Duration(minutes: 30)));
    converted.add(DateTimeRange(start: newBooking.bookingStart, end: newBooking.bookingEnd));
    print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultAppointment({required dynamic streamResult}) {
    ///database read
    converted = globalConverted;
    return converted;
  }



  @override
  Widget build(BuildContext context) {
    final String currentBarbershopValue = ref.watch(currentBarbershopProvider);
    final List<DateTimeRange> currentBookedHoursValue = ref.watch(currentBookedHoursProvider);
    final DateTime currentlySelectedDay = ref.watch(selectedDate);
    //print(currentlySelectedDay);
    globalCurrentBarbershopName = currentBarbershopValue;
    globalConverted = currentBookedHoursValue;
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
          currentBarbershopValue: currentBarbershopValue,
          availableHours: 8, //(DateTime.now().hour > 10 && currentlySelectedDay.day == DateTime.now().day) ? 8 - (DateTime.now().hour - 10) : 8
          startingHours: 10, //(DateTime.now().hour > 10 && currentlySelectedDay.day == DateTime.now().day) ? DateTime.now().hour+1 : 10
        ),
      )
    );
  }

  Future<void> insertData(String userId, String barbershopName, DateTime bookingTime, DateTime bookingEndTime) async {
    final appointmentId = const Uuid().v5(Uuid.NAMESPACE_URL, barbershopName + bookingTime.millisecondsSinceEpoch.toString());
    //if(appointmentId) {
      try {
        await databaseRef.child(appointmentId).set({
          'userId': userId,
          'barbershopName': barbershopName,
          'bookingTime': bookingTime.millisecondsSinceEpoch,
          'bookingEndTime': bookingEndTime.millisecondsSinceEpoch
        });
        print("Added to database");
      } catch (e) {
        print("Error! $e");
      }
    //}
  }

}
