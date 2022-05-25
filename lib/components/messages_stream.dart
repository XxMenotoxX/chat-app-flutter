import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:halawa_naim_chat/screens/chat_screen.dart';

import 'message_bubble.dart';

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    Key? key,
    required this.fireStore,
  }) : super(key: key);

  final FirebaseFirestore fireStore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var msg in messages) {
            final messageText = msg.get('text');
            final messageSender = msg.get('sender');
            final messageTime = msg.get('time') as Timestamp;
            final currentUser = loggedInUser.email;
            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              time: messageTime,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
            messageBubbles.sort((a, b) => b.time.compareTo(a.time));
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            ),
          );
        } else {
          return const Center(
            child: SpinKitHourGlass(
              color: Colors.indigo,
              size: 100,
            ),
          );
        }
      },
    );
  }
}