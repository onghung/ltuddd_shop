import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/model_chat.dart';
import 'components/mesage_widget.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = "/chats";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Chat'),
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
                    return MessageWidget(message: message);
                  },
                );
              },
            ),
          ),
          // Phần nhập tin nhắn
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
                    // Gửi tin nhắn lên Firestore
                    if (_messageController.text.isNotEmpty) {
                      ChatMessage message = ChatMessage(
                        user: '${user.email}',
                        contact: 'admin@gmail.com',
                        text: _messageController.text,
                        date: DateTime.now(),
                      );

                      FirebaseFirestore.instance
                          .collection('/ltuddd/5I19DY1GyC83pHREVndb/chat')
                          .add(message.toMap());

                      // Xóa nội dung trong ô nhập tin nhắn sau khi gửi
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


