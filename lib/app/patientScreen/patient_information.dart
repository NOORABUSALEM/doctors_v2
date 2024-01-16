// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docotors_02/app/patientScreen/add_eye.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../extraWidget/pick_Img.dart';
import 'patient_information_edit.dart';

class PatientInfoWidget extends StatelessWidget {
  final DocumentSnapshot person;

  const PatientInfoWidget({
    super.key,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    const uuid = Uuid();
    var id = uuid.v4();
    Reference storgeref = FirebaseStorage.instance
        .ref()
        .child('pations')
        .child('eyespictures')
        .child(person.id)
        .child('$id.jpg');
    final age = DateTime.now().year - person['birthday'].toDate().year;
    final caseHistory =
        person['caseHistory'].toDate().day - DateTime.now().day + 1;
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  width: double.infinity,
                  height: 200.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          //   person['imgUrl'] != ''
                          //   ? person['imgUrl'] :
                          'assets/images/accountImg.webp'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientInfoEditWidget(
                            person: person,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: GetImgFromUser(
                    myicon: SizedBox(
                      height: 40,
                      child: Image.asset('assets/icons/add_eye.png'),
                    ),
                    storgeref: storgeref,
                    makingChageingofDatabase: () async {
                      final imageUrl = await storgeref.getDownloadURL();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEye(
                                  imageUrl: imageUrl,
                                  person: person,
                                )),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${person["firstName"]} ${person["lastName"]}',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    _buildInfoRow('Age', age.toString()),
                    _buildInfoRow('Phone', person['phone']),
                    // _buildInfoRow('Insurance Company', person['insuranceCompany']),
                    const SizedBox(height: 16.0),
                    Text(
                      'Medical History',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    _buildDivider(),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Eye Conditions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(person['allergyEyeConditions'].join(", ")),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Case History',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${caseHistory.toString()} day'),
                    const SizedBox(height: 8.0),
                    if (person['allergyName'].isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Allergy Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(person['allergyName']),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Degree of Allergy',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(person['degreeOfAllergy']),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Allergy Treatment',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(person['allergyTreatment']),
                          const SizedBox(height: 8.0),
                        ],
                      ),
                    Text(
                      'Doctor Notes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    _buildDivider(),
                    const SizedBox(height: 8.0),
                    Text(person['doctorNotes']),
                    const SizedBox(height: 16.0),
                    Text(
                      'eye pictures ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    _buildDivider(),
                    const SizedBox(height: 16.0),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('eye_picture')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (streamSnapshot.hasError) {
                            return const Center(
                              child: Text('someting went wrong ...'),
                            );
                          }
                          final loadedData = streamSnapshot.data!.docs
                              .where((eye) => eye['patientId'] == person.id)
                              .toList();
                          if (!streamSnapshot.hasData ||
                              streamSnapshot.data!.docs.isEmpty ||
                              loadedData.isEmpty) {
                            return const Center(
                              child: Text('No pictures found .'),
                            );
                          }
                          //final otherData = loadedData.map((e) => )
                          return ListView.builder(
                              itemCount: loadedData.length,
                              itemBuilder: (context, index) {
                                final person = loadedData[index];
                                return GestureDetector(
                                    onTap: () async {
                                      // await Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           PatientInfoWidget(
                                      //             person: person,
                                      //           )),
                                      // );
                                    },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        color: Theme.of(context).primaryColor,
                                        child: Image.network(
                                            person['image_url'])));
                              });
                        }),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(value),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.0,
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }
}
