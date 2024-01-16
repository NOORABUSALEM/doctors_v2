// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final CollectionReference _patients =
      FirebaseFirestore.instance.collection('patients');
  final dateFormat = DateFormat.yMd();
  int _currentStep = 0;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  DateTime? _birthday;
  final TextEditingController _contactController = TextEditingController();

  final List<String> _eyeConditions = [
    'Eye Inflammation',
    'Dryness',
    'Cyanosis',
    'Night Fatigue',
    'Glaucoma',
    'Cataract',
    'Corneal Ulcer',
    'Others',
  ];
  final List<String> _selectedEyeConditions = [];

  DateTime? _caseHistory;
  bool _hasAllergy = false;
  final TextEditingController _allergyNameController = TextEditingController();
  final List<String> _allergySymptoms = [
    'Itch',
    'Eye redness',
    'Congestion and swelling',
    'Sensitivity to light',
    'Excessive tears',
    'A burning sensation',
    'Secretions',
    'Feeling of a foreign body',
  ];
  final List<String> _selectedAllergySymptoms = [];
  String _selectedDegreeOfAllergy = 'Light';

  final TextEditingController _allergyTreatmentController =
      TextEditingController();
  final TextEditingController _doctorNotesController = TextEditingController();
  final TextEditingController _insuranceCompanyController =
      TextEditingController();
  final TextEditingController _insuranceCardNumberController =
      TextEditingController();

  final Color black = Colors.black;
  final Color red = Colors.red;

  String? _firstNameError;
  String? _lastNameError;
  Color _birthdayError = Colors.grey;
  String? _contactError;

  Color _eyeConditionsColor = Colors.black;
  Color _allergyEyeConditions = Colors.black;
  Color _caseHistoryErr = Colors.grey;
  String? _insuranceCompanyErr;
  String? _insuranceCardNumberErr;

  String? _allergyNameErr;
  String? _allergyTreatmentErr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Patient'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if ((_validateFirstStep() && _currentStep == 0) ||
              (_validateSecondStep() && _currentStep == 1)) {
            setState(() {
              _currentStep++;
            });
          } else if (_validateThirdStep()) {
            setState(() async {
              await _patients.add({
                'firstName': _firstNameController.text,
                'lastName': _lastNameController.text,
                'birthday': _birthday!,
                'eyeConditions': _selectedEyeConditions,
                'caseHistory': _caseHistory!,
                'allergyName': _allergyNameController.text,
                'allergyEyeConditions': _selectedAllergySymptoms,
                'degreeOfAllergy': _selectedDegreeOfAllergy,
                'allergyTreatment': _allergyTreatmentController.text,
                'doctorNotes': _doctorNotesController.text,
                'phone': _contactController.text
              });
              Navigator.pop(context);
            });
          }
        },
        onStepCancel: () {
          setState(() {
            _currentStep > 0 ? _currentStep-- : Navigator.pop(context);
          });
        },
        steps: [
          Step(
            title: const Text('Basic Information'),
            isActive: _currentStep == 0,
            content: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    errorText: _firstNameError,
                  ),
                  keyboardType: TextInputType.name,
                  // Display error message if not null
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                      labelText: 'Last Name', errorText: _lastNameError),
                  keyboardType: TextInputType.name,
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Birth day ',
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        _birthday == null
                            ? 'no date selected'
                            : dateFormat.format(_birthday!),
                        style: TextStyle(
                          color: _birthdayError,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final now = DateTime.now();
                          final firstDate =
                              DateTime(now.year - 150, now.month, now.day);
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: firstDate,
                            lastDate: now,
                          );

                          setState(() {
                            _birthday = pickedDate;
                            _birthdayError = black;
                          });
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(
                      labelText: 'Phone', errorText: _contactError),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Medical History'),
            isActive: _currentStep == 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Eye Conditions',
                    style: TextStyle(color: _eyeConditionsColor, fontSize: 17)),
                Wrap(
                  children: _eyeConditions.map((condition) {
                    return FilterChip(
                      label: Text(condition),
                      selected: _selectedEyeConditions.contains(condition),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedEyeConditions.add(condition);
                          } else {
                            _selectedEyeConditions.remove(condition);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Case History ',
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        _caseHistory == null
                            ? 'no date selected'
                            : dateFormat.format(_caseHistory!),
                        style: TextStyle(
                          color: _caseHistoryErr,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final now = DateTime.now();
                          final firstDate =
                              DateTime(now.year - 150, now.month, now.day);
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: firstDate,
                            lastDate: now,
                          );

                          setState(() {
                            _caseHistory = pickedDate;
                            _caseHistoryErr = black;
                          });
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _hasAllergy,
                      onChanged: (value) {
                        setState(() {
                          _hasAllergy = value ?? false;
                        });
                      },
                    ),
                    const Text('Has Allergy'),
                  ],
                ),
                if (_hasAllergy)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _allergyNameController,
                        decoration: InputDecoration(
                            labelText: 'Allergy Name',
                            errorText: _allergyNameErr),
                      ),
                      const SizedBox(height: 20),
                      Text('Eye Conditions',
                          style: TextStyle(
                              fontSize: 17, color: _allergyEyeConditions)),
                      const SizedBox(height: 20),
                      Wrap(
                        children: _allergySymptoms.map((condition) {
                          return FilterChip(
                            label: Text(condition),
                            selected:
                                _selectedAllergySymptoms.contains(condition),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedAllergySymptoms.add(condition);
                                } else {
                                  _selectedAllergySymptoms.remove(condition);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text('Degree of Allergy',
                          style: TextStyle(fontSize: 17)),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            RadioListTile<String>(
                              title: const Text('Light'),
                              value: 'Light',
                              groupValue: _selectedDegreeOfAllergy,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedDegreeOfAllergy = value!;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: const Text('Medium'),
                              value: 'Medium',
                              groupValue: _selectedDegreeOfAllergy,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedDegreeOfAllergy = value!;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: const Text('High'),
                              value: 'High',
                              groupValue: _selectedDegreeOfAllergy,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedDegreeOfAllergy = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: _allergyTreatmentController,
                        decoration: InputDecoration(
                            labelText: 'Allergy Treatment',
                            errorText: _allergyTreatmentErr),
                      ),
                    ],
                  ),
                TextFormField(
                  controller: _doctorNotesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Doctor Notes',
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Insurance'),
            isActive: _currentStep == 2,
            content: Column(
              children: [
                TextFormField(
                  controller: _insuranceCompanyController,
                  decoration: InputDecoration(
                      labelText: 'Insurance Company',
                      errorText: _insuranceCompanyErr),
                ),
                TextFormField(
                  controller: _insuranceCardNumberController,
                  decoration: InputDecoration(
                      labelText: 'Insurance Card Number',
                      errorText: _insuranceCardNumberErr),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to validate the first step fields
  bool _validateFirstStep() {
    bool isValid = true;

    if (_firstNameController.text.isEmpty) {
      setState(() {
        _firstNameError = 'Please enter your first name';
        isValid = false;
      });
    } else {
      setState(() {
        _firstNameError = null;
      });
    }

    if (_lastNameController.text.isEmpty) {
      setState(() {
        _lastNameError = 'Please enter your last name';
        isValid = false;
      });
    } else {
      setState(() {
        _lastNameError = null;
      });
    }

    if (_birthday == null) {
      setState(() {
        _birthdayError = Colors.red;
        isValid = false;
      });
    }
    if (_contactController.text.isEmpty) {
      setState(() {
        _contactError = 'Please enter your phone number';
        isValid = false;
      });
    } else {
      setState(() {
        _contactError = null;
      });
    }

    return isValid;
  }

  // Helper method to validate the Second step fields
  bool _validateSecondStep() {
    bool isValid = true;

    if (_selectedEyeConditions.isEmpty) {
      setState(() {
        _eyeConditionsColor = red;
        isValid = false;
      });
    } else {
      setState(() {
        _eyeConditionsColor = black;
      });
    }
    if (_caseHistory == null) {
      setState(() {
        _caseHistoryErr = Colors.red;
        isValid = false;
      });
    }

    if (_hasAllergy) {
      if (_allergyNameController.text.isEmpty) {
        setState(() {
          _allergyNameErr = 'Please enter your first name';
          isValid = false;
        });
      } else {
        setState(() {
          _allergyNameErr = null;
        });
      }

      if (_selectedAllergySymptoms.isEmpty) {
        setState(() {
          _allergyEyeConditions = red;
          isValid = false;
        });
      } else {
        setState(() {
          _allergyEyeConditions = black;
        });
      }

      if (_allergyTreatmentController.text.isEmpty) {
        setState(() {
          _allergyTreatmentErr = 'Please enter your last name';
          isValid = false;
        });
      } else {
        setState(() {
          _allergyTreatmentErr = null;
        });
      }
    }
    return isValid;
  }

  // Helper method to validate the Third step fields
  bool _validateThirdStep() {
    bool isValid = true;

    if (_insuranceCompanyController.text.isEmpty) {
      setState(() {
        _insuranceCompanyErr = 'Please enter your Comany name';
        isValid = false;
      });
    } else {
      setState(() {
        _insuranceCompanyErr = null;
      });
    }

    if (_insuranceCardNumberController.text.isEmpty) {
      setState(() {
        _insuranceCardNumberErr = 'Please enter your Card number';
        isValid = false;
      });
    } else {
      setState(() {
        _insuranceCardNumberErr = null;
      });
    }
    return isValid;
  }
}
