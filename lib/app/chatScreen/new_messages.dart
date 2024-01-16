// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();

    dispose() {
      super.dispose();
      messageController.dispose();
    }

    sendMessage() async {
      final entredMessage = messageController.text;
      if (entredMessage.trim().isEmpty) {
        return;
      }
      messageController.clear();
      final User user = FirebaseAuth.instance.currentUser!;
      final userdata = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      await FirebaseFirestore.instance.collection('chat').add({
        'text': entredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'user_name': userdata.data()!['username'],
        'image_url': userdata.data()!['image_url'],
      });
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 1, 14),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: messageController,
            onTap: () {
              sendMessage();
            },
            autocorrect: true,
            enableSuggestions: true,
            decoration: const InputDecoration(labelText: 'send massege'),
            textCapitalization: TextCapitalization.sentences,
          )),
          IconButton(
              onPressed: () {
                sendMessage();
              },
              icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
