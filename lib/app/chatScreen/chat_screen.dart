import 'package:flutter/material.dart';

import 'chat_messages.dart';
import 'new_messages.dart';

class ChatingScreen extends StatelessWidget {
  const ChatingScreen({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: const Column(
        children: [
          Expanded(child: ChatMessages()),
          NewMessage(),
        ],
      ),
    );
  }
}
