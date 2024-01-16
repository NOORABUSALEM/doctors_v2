import 'package:docotors_02/app/appointmentScreen/appointment_screen.dart';
import 'package:docotors_02/app/chatScreen/chat_screen.dart';
import 'package:flutter/material.dart';

import 'home_screen/home_screen.dart';
import 'patientScreen/patient_screen.dart';

class TapBar extends StatefulWidget {
  final void Function() signout;

  const TapBar({super.key, required this.signout});

  @override
  MyTapBar createState() => MyTapBar();
}

class MyTapBar extends State<TapBar> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(signout: widget.signout),
      AppointmentScreen(),
      const PatientScreen(),
      const ChatingScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 58, 183, 154),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 58, 183, 154),
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 58, 183, 154),
            icon: Icon(Icons.people),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 58, 183, 154),
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
