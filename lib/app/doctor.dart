import 'package:docotors_02/app/sign_up_in/sign_up_screen.dart';
import 'package:flutter/material.dart';

import 'sign_up_in/sign_in_screens.dart';
import 'tab_bar.dart';

class Doctor extends StatefulWidget {
  const Doctor({super.key});

  @override
  State<Doctor> createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  Widget? activeScreen;

  void sucssLogin() {
    setState(() {
      activeScreen = TapBar(
        signout: signout,
      );
    });
  }

  void signup() {
    setState(() {
      activeScreen = SignUp(successfullyLogIn: sucssLogin, logIn: signout);
    });
  }

  void signout() {
    setState(() {
      activeScreen = SignIn(successfullyLogIn: sucssLogin, signup: signup);
    });
  }

  @override
  void initState() {
    super.initState();
    activeScreen = SignIn(
      successfullyLogIn: sucssLogin,
      signup: signup,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(202, 58, 183, 154),
          Color.fromARGB(255, 58, 183, 154),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: activeScreen,
      ),
    );
  }
}
