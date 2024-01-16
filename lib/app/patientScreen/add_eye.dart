// ignore_for_file: use_build_context_synchronously, must_be_immutable, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEye extends StatefulWidget {
  AddEye({super.key, required this.imageUrl, required this.person});
  final DocumentSnapshot person;
  String? imageUrl;

  @override
  _AddEyeState createState() => _AddEyeState();
}

class _AddEyeState extends State<AddEye> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Future _pickImage() async {
  //   final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedImage == null) return;

  //   final imageFile = File(pickedImage.path);
  //   setState(() {
  //     _selectedImage = imageFile;
  //   });
  // }

  // void _uploadImage() async {
  //   if (_selectedImage == null) return;

  //   final storageRef = FirebaseStorage.instance.ref().child('images').child('my_image.jpg');
  //   await storageRef.putFile(_selectedImage!);
  //   final imageUrl = await storageRef.getDownloadURL();

  //   setState(() {
  //     _imageUrl = imageUrl;
  //   });
  // }

  void _deleteImage() {
    setState(() {
      widget.imageUrl = null;
    });
  }

  void _saveData() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final date = _dateController.text;

    if (name.isNotEmpty && description.isNotEmpty && date.isNotEmpty) {
      // Save data to Firebase
      await FirebaseFirestore.instance.collection('eye_picture').add({
        'patientId': widget.person.id,
        'name': name,
        'description': description,
        'date': date,
        'image_url': widget.imageUrl,
      });
      // Clear text fields
      Navigator.pop(context);

      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Data saved successfully!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add eye pictuer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.imageUrl != null)
                Image.network(
                  widget.imageUrl!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                ),
                onTap: () {
                  setState(() {
                    _dateController.text =
                        DateTime.now().toString().substring(0, 10);
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveData,
                      child: const Text('Done'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _deleteImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
