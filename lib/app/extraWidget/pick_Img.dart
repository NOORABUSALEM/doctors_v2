// ignore_for_file: use_build_context_synchronously, must_be_immutable, file_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GetImgFromUser extends StatefulWidget {
  GetImgFromUser(
      {super.key,
      required this.myicon,
      required this.storgeref,
      required this.makingChageingofDatabase});

  Widget myicon;
  Reference storgeref;
  Function() makingChageingofDatabase;
  @override
  State<GetImgFromUser> createState() => _GetImgFromUserState();
}

class _GetImgFromUserState extends State<GetImgFromUser> {
  File? _selectedImage;

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickimageFromCamera(false);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text('Gallery')
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickimageFromCamera(true);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera,
                            size: 70,
                          ),
                          Text('Camera')
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future _pickimageFromCamera(bool i) async {
    final returnImage = await ImagePicker()
        .pickImage(source: i ? ImageSource.camera : ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      _selectedImage = File(returnImage.path);
    });

    Navigator.of(context).pop();

    await widget.storgeref.putFile(_selectedImage!);
    widget.makingChageingofDatabase();
    // final imageUrl = await storgeref.getDownloadURL();

    // final userdata = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(user.uid)
    //     .get();
    // FirebaseFirestore.instance.collection('users').doc(userdata.id).set({
    //   'username':
    //       userdata.data()!['username'], // Use the text value of the controller
    //   'email': userdata.data()!['email'],
    //   'image_url': imageUrl,
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showImagePickerOption(context);
        },
        child: widget.myicon);
  }
}
