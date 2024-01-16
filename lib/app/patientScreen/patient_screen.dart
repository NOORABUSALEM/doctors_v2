// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add_patient_screen.dart';
import 'patient_information.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final CollectionReference _patients =
      FirebaseFirestore.instance.collection('patients');
  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('patients '),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('patients')
              .orderBy('firstName', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No patients found .'),
              );
            }
            if (streamSnapshot.hasError) {
              return const Center(
                child: Text('someting went wrong ...'),
              );
            }
            final loadedData = streamSnapshot.data!.docs;
            //final otherData = loadedData.map((e) => )
            return ListView.builder(
                itemCount: loadedData.length,
                itemBuilder: (context, index) {
                  final person = loadedData[index];
                  final age =
                      DateTime.now().year - person['birthday'].toDate().year;
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PatientInfoWidget(
                                  person: person,
                                )),
                      );
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.account_circle),
                          ),
                          title: Text(
                            '${person["firstName"]} ${person["lastName"]}',
                          ),
                          subtitle: Text("age : $age"),
                          trailing: SizedBox(
                              width: 100,
                              child: IconButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text('Warning :'),
                                            content: Text(
                                                'the ${person["firstName"]} ${person["lastName"]} well be delete from data base .'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )),
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await _patients
                                                        .doc(person.id)
                                                        .delete();
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ))
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.black45,
                                  ))),
                        )),
                  );
                });
          }),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPatientScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
// final dateFormat = DateFormat.yMd();
// static const uuid = Uuid();
// final TextEditingController _searchController = TextEditingController();
// List<Person> filteredPersons = [];
// final List<String> _selectedEyeConditions = [];
// final List<String> _eyeConditions = [
//   'Eye Inflammation',
//   'Dryness',
//   'Cyanosis',
//   'Night Fatigue',
//   'Glaucoma',
//   'Cataract',
//   'Corneal Ulcer',
//   'Others',
// ];

// @override
// void initState() {
//   super.initState();
//   filteredPersons = List.from(boxPerson.values);
//   _searchController.addListener(_filterCards);
// }

// @override
// void dispose() {
//   _searchController.dispose();
//   super.dispose();
// }

// void _filterCards() {
//   var searchQuery = _searchController.text;
//   setState(() {
//     searchQuery = searchQuery.toLowerCase();
//     filteredPersons = boxPerson.values
//         .where((person) {
//           final fullName =
//               '${person.firstName} ${person.lastName}'.toLowerCase();
//           return person.phone.contains(searchQuery.toString()) &&
//               fullName.contains(searchQuery) &&
//               _selectedEyeConditions.every(person.eyeConditions.contains);
//         })
//         .toList()
//         .cast<Person>();
//   });
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Patients'),
//       backgroundColor: Colors.white,
//     ),
//     body: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             controller: _searchController,
//             decoration: const InputDecoration(
//               prefixIcon: Icon(Icons.search),
//               labelText: 'Search',
//               border: OutlineInputBorder(),
//             ),
//             onChanged: (_) => _filterCards(),
//           ),
//         ),
//         Wrap(
//           children: _eyeConditions.map((condition) {
//             return FilterChip(
//               label: Text(condition),
//               selected: _selectedEyeConditions.contains(condition),
//               onSelected: (selected) {
//                 setState(() {
//                   if (selected) {
//                     _selectedEyeConditions.add(condition);
//                   } else {
//                     _selectedEyeConditions.remove(condition);
//                   }
//                   _filterCards();
//                 });
//               },
//             );
//           }).toList(),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: filteredPersons.length,
//             itemBuilder: (context, index) {
//               Person person = filteredPersons[index];
//               return GestureDetector(
//                 onTap: () => {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           PersonDetailsScreen(person: person),
//                     ),
//                   )
//                 },
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   color: Theme.of(context).secondaryHeaderColor,
//                   child: ListTile(
//                     leading: const CircleAvatar(
//                       child: Icon(Icons.account_circle),
//                     ),
//                     title: Text(person.firstName,
//                         semanticsLabel: person.lastName),
//                     subtitle: Text(person.lastName),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//     floatingActionButton: FloatingActionButton(
//       onPressed: () {
//         _navigateToAddPatientScreen();
//       },
//       child: const Icon(Icons.add),
//     ),
//   );
// }

// Future<void> _navigateToAddPatientScreen() async {
//   final result = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => AddPatientScreen()),
//   );

//   if (result != null && result is Person) {
//     setState(() {
//       boxPerson.put(uuid.v4(), result);
//     });
//   }
// }
