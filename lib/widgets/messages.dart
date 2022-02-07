import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (chatSnapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemBuilder: (ctx, index) {
              return MessageBubble(
                message: chatSnapshot.data!.docs[index]['text'],
                isMe: chatSnapshot.data!.docs[index]['userId'] ==
                    FirebaseAuth.instance.currentUser!.uid,
                userName: chatSnapshot.data!.docs[index]['userName'],
                userAvatar: chatSnapshot.data!.docs[index]['userImage']
              );
            },
            itemCount: chatSnapshot.data!.docs.length,
            reverse: true,
          );
        }
        return const Text('No messages');
      },
    );
  }
}
