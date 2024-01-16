// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Logowidet extends StatelessWidget {
  const Logowidet({super.key, required this.imgname});
  final String imgname;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imgname,
      fit: BoxFit.contain,
      width: 150,
      height: 200,
      color: Colors.white,
    );
  }
}
