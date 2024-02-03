import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../model/model_chat.dart';

class MessageWidget extends StatelessWidget {
  final ChatMessage message;
  final bool isSentByUser;

  const MessageWidget({Key? key, required this.message, required this.isSentByUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSentByUser ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: const TextStyle(color: Colors.white),
                ),
                if (message.imageUrl.isNotEmpty)
                  Image.network(
                    message.imageUrl,
                    height: 100,
                    width: 100,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
