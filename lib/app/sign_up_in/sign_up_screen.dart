// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docotors_02/app/sign_up_in/extra/reuesd_textfild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'extra/reusedButton.dart';

class SignUp extends StatefulWidget {
  const SignUp(
      {super.key, required this.successfullyLogIn, required this.logIn});

  @override
  State<SignUp> createState() => _SignUpState();
  final void Function() successfullyLogIn;
  final void Function() logIn;
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _pasewordTextController = TextEditingController();
  String email = '';
  String password = '';
  String name = '';
  bool _isUploading = false;

  void _handleSignUp() async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username':
            _nameTextController.text, // Use the text value of the controller
        'email': email,
        'image_url': '',
      });
      widget.successfullyLogIn();

      log("User Registered: $userCredential");
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      log("Error During Registration: $e");
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
            20, MediaQuery.of(context).size.height * 0.1, 20, 0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              //const Logowidet(imgname: 'assets/images/doctor_img.png'),
              //const Logowidet(imgname: 'assets/images/doctor_img.png'),
              Image.asset(
                'assets/images/doctor_img.png',
                fit: BoxFit.contain,
                width: 150,
                height: 200,
                color: Colors.white,
              ),
              const SizedBox(
                height: 30,
              ),
              reusedTextField(
                text: 'Enter UserName',
                icon: Icons.person_outline,
                ispassword: false,
                controller: _nameTextController,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
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
              const SizedBox(
                height: 20,
              ),
              if (_isUploading) const CircularProgressIndicator(),
              if (!_isUploading)
                resuedSignUpButton(
                  isLogin: false,
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      _isUploading = true;
                    });

                    if (_formkey.currentState!.validate()) {
                      _handleSignUp();
                    }
                  },
                  context: context,
                ),
              if (!_isUploading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("I all ready have account",
                        style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: () {
                        widget.logIn();
                      },
                      child: const Text(
                        'Sign IN',
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
