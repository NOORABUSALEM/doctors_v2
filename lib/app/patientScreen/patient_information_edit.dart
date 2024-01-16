// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientInfoEditWidget extends StatefulWidget {
  final DocumentSnapshot person;

  const PatientInfoEditWidget({super.key, required this.person});

  @override
  _PatientInfoEditWidgetState createState() => _PatientInfoEditWidgetState();
}

class _PatientInfoEditWidgetState extends State<PatientInfoEditWidget> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthdayController;
  late TextEditingController _phoneController;
  late TextEditingController _doctorNotesController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.person['firstName']);
    _lastNameController =
        TextEditingController(text: widget.person['lastName']);
    _birthdayController = TextEditingController(
        text: widget.person['birthday'].toDate().toString());
    _phoneController = TextEditingController(text: widget.person['phone']);
    _doctorNotesController =
        TextEditingController(text: widget.person['doctorNotes']);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthdayController.dispose();
    _phoneController.dispose();
    _doctorNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Patient Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _birthdayController,
              decoration: const InputDecoration(labelText: 'Birthday'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _doctorNotesController,
              decoration: const InputDecoration(labelText: ' Doctors Note'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updatePatientInfo();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePatientInfo() {
    final updatedData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'birthday': DateTime.parse(_birthdayController.text),
      'phone': _phoneController.text,
      'doctorNotes': _doctorNotesController.text,
    };

    widget.person.reference.update(updatedData).then((value) {
      // Data updated successfully
      Navigator.pop(context);
    }).catchError((error) {
      // Error occurred while updating data
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content:
              const Text('Failed to update patient info. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}
