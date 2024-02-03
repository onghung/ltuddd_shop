import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/model_chat.dart';
import '../screens/chat/components/mesage_widget.dart';

class ChatScreenadm extends StatefulWidget {
  static String routeName = "/chatsadm";
  final String contactEmail;

  ChatScreenadm({required this.contactEmail});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenadm> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Trò chuyện"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('/ltuddd/5I19DY1GyC83pHREVndb/chat')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    ChatMessage message = ChatMessage.fromDocument(messages[index]);
                    bool isSentByUser = user.email == message.user;
                    return MessageWidget(message: message, isSentByUser: isSentByUser);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Gửi tin nhắn à Firestore
                    if (_messageController.text.isNotEmpty) {
                      ChatMessage message = ChatMessage(
                        user: '${user.email}',
                        contact: widget.contactEmail,
                        text: _messageController.text,
                        date: DateTime.now(),
                      );

                      FirebaseFirestore.instance
                          .collection('/ltuddd/5I19DY1GyC83pHREVndb/chat')
                          .add(message.toMap());

                      // Effacer le contenu dans la zone de texte après envoi
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
