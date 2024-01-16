// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'extra/reuesd_textfild.dart';
import 'extra/reusedButton.dart';

class SignIn extends StatefulWidget {
  const SignIn(
      {super.key, required this.successfullyLogIn, required this.signup});

  @override
  State<SignIn> createState() => _SignInState();
  final void Function() successfullyLogIn;
  final void Function() signup;
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _pasewordTextController = TextEditingController();
  String email = '';
  String password = '';
  bool _isUploading = false;

  void _handleSignIn() async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      widget.successfullyLogIn();
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      log("Error During Registration : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(202, 58, 183, 154),
          Color.fromARGB(255, 58, 183, 154),
        ],
      )),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.height * 0.2, 20, 0),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              //const Logowidet(imgname: 'assets/images/doctor_img.png'),
              Image.asset(
                'assets/images/doctor_img.png',
                fit: BoxFit.contain,
                width: 150,
                height: 200,
                color: Colors.white,
              ),
              reusedTextField(
                text: 'Enter Email ',
                icon: Icons.email_outlined,
                ispassword: false,
                controller: _emailTextController,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please Enter your Email";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              reusedTextField(
                text: 'Enter password',
                icon: Icons.lock_outline,
                ispassword: true,
                controller: _pasewordTextController,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please Enter your password";
                  }
                  return null;
                },
              ),
              if (_isUploading) const CircularProgressIndicator(),
              const SizedBox(
                height: 20,
              ),
              if (!_isUploading)
                resuedSignUpButton(
                  isLogin: true,
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      _isUploading = true;
                    });
                    if (formkey.currentState!.validate()) {
                      _handleSignIn();
                    }
                  },
                  context: context,
                ),
              if (!_isUploading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("I don't  have account ",
                        style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: () {
                        widget.signup();
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
            ]),
          ),
        ),
      ),
    ));
  }
}
