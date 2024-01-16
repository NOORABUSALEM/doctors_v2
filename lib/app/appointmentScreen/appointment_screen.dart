import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class Event {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;

  Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  List<Event> events = [
    Event(
      title: 'Event A',
      startTime: DateTime.now().add(Duration(hours: 10)),
      endTime: DateTime.now().add(Duration(hours: 12)),
      color: Colors.blue[700]!,
    ),
    Event(
      title: 'Event B',
      startTime: DateTime.now().add(Duration(days: 2, hours: 10)),
      endTime: DateTime.now().add(Duration(days: 2, hours: 12)),
      color: Colors.orange,
    ),
    Event(
      title: 'Event C',
      startTime: DateTime.now().add(Duration(days: 2, hours: 14, minutes: 30)),
      endTime: DateTime.now().add(Duration(days: 2, hours: 17)),
      color: Colors.pink,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Screen'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: _getCalendarDataSource(),
          initialDisplayDate: selectedDate,
          monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          ),
        ),
      ),
    );
  }

  _AppointmentDataSource _getCalendarDataSource() {
    final List<Appointment> appointments = events
        .map((event) => Appointment(
              startTime: event.startTime,
              endTime: event.endTime,
              subject: event.title,
              color: event.color,
            ))
        .toList();
    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}

void main() {
  runApp(AppointmentApp());
}

class AppointmentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AppointmentScreen(),
    );
  }
}
