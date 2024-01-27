import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String user;
  String contact;
  String text;
  DateTime date;
  String imageUrl;

  ChatMessage({
    required this.user,
    required this.contact,
    required this.text,
    required this.date,
    this.imageUrl = '',
  });

  // Chuyển đổi dữ liệu từ Firestore thành đối tượng ChatMessage
  factory ChatMessage.fromDocument(DocumentSnapshot document) {
    Map data = document.data() as Map;
    return ChatMessage(
      user: data['user'] ?? '',
      contact: data['contact'] ?? '',
      text: data['text'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Chuyển đổi đối tượng ChatMessage thành dữ liệu để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'contact': contact,
      'text': text,
      'date': date,
      'imageUrl': imageUrl,
    };
  }
}
