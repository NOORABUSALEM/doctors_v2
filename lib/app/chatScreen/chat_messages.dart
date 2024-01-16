import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found .'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('someting went wrong ...'),
            );
          }
          final loadedMessages = snapshot.data!.docs;

          return ListView.builder(
              padding: const EdgeInsets.fromLTRB(13, 0, 13, 40),
              reverse: true,
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index) {
                final chatMessages = loadedMessages[index].data();
                final nextMessage = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1].data()
                    : null;

                final currentMessageUserId = chatMessages['userId'];
                final nextMessageUserId =
                    nextMessage != null ? chatMessages['userId'] : null;

                final bool nextUserIsSame =
                    nextMessageUserId == currentMessageUserId;

                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessages['text'],
                      isMe: authUser.uid == currentMessageUserId);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessages['image_url'],
                      username: chatMessages['user_name'],
                      message: chatMessages['text'],
                      isMe: authUser.uid == currentMessageUserId);
                }
              });
        });
  }
}
