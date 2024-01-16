// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MedicalDeviceAdvertisement extends StatelessWidget {
  final String imageURL;
  final VoidCallback? onTap;

  const MedicalDeviceAdvertisement({required this.imageURL, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey[200], // Adjust as per your design
        ),
        child: Image.network(
          imageURL,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
