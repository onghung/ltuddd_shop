// import 'package:flutter/material.dart';
// import '../../../model/model_chat.dart';
//
// class MessageWidget extends StatelessWidget {
//   final ChatMessage message;
//   final bool isSentByAdmin;
//
//   const MessageWidget({Key? key, required this.message, required this.isSentByAdmin}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//       decoration: BoxDecoration(
//         color: isSentByAdmin ? Colors.blueGrey[100] : Colors.blue[300],
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             message.user,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: isSentByAdmin ? Colors.blueGrey[800] : Colors.white,
//             ),
//           ),
//           Text(
//             message.text,
//             style: TextStyle(
//               color: isSentByAdmin ? Colors.blueGrey[800] : Colors.white,
//             ),
//           ),
//           Align(
//             alignment: isSentByAdmin ? Alignment.centerLeft : Alignment.centerRight,
//             child: Text(
//               "${message.date.toLocal()}",
//               style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 fontSize: 10.0,
//                 color: isSentByAdmin ? Colors.blueGrey[800] : Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
