// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ReUploadImg extends StatefulWidget {
//   const ReUploadImg({Key? key}) : super(key: key);
//
//   @override
//   _ReUploadImg createState() => _ReUploadImg();
// }
//
// class _ReUploadImg extends State<ReUploadImg> {
//   Future<void> _openGallery() async {
//     final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       await _uploadImageAndAddToFirestore(image);
//     }
//   }
//
//   Future<void> _openCamera() async {
//     final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
//
//     if (image != null) {
//       await _uploadImageAndAddToFirestore(image);
//     }
//   }
//
//   Future<void> _uploadImageAndAddToFirestore(XFile image) async {
//     try {
//       // Upload image to Firebase Storage
//       String imageUrl = await _uploadImageToStorage(image);
//
//       // Add image information to Firestore
//       await _addImageInfoToFirestore(imageUrl);
//
//       // You can perform additional actions after successfully adding the image, if needed
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   Future<String> _uploadImageToStorage(XFile image) async {
//     Reference storageReference = FirebaseStorage.instance
//         .ref()
//         .child('img/product/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
//
//     UploadTask uploadTask = storageReference.putFile(File(image.path));
//     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
//
//     return await taskSnapshot.ref.getDownloadURL();
//   }
//
//   Future<void> _addImageInfoToFirestore(String imageUrl) async {
//     try {
//       await FirebaseFirestore.instance.collection('/ltuddd/5I19DY1GyC83pHREVndb/Product').add({
//         'imageUrl': imageUrl,
//         'description': "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …",
//         'id': "SP01",
//         'isFavourite':true,
//         'price':700000,
//         'rating':4,
//         'title':"Wireless Controller for PS4"
//       });
//
//       print('Image added to Firestore with URL: $imageUrl');
//     } catch (e) {
//       print('Error adding image to Firestore: $e');
//     }
//   }
//
//   Future<void> _showOptions() async {
//     return showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 120,
//           child: Column(
//             children: <Widget>[
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('Open Gallery'),
//                 onTap: () {
//                   _openGallery();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('Open Camera'),
//                 onTap: () {
//                   _openCamera();
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   // Widget build(BuildContext context) {
//   //   return GestureDetector(
//   //     onTap: _showOptions,
//   //     child: Container(
//   //       width: 60,
//   //       height: 60,
//   //       decoration: BoxDecoration(
//   //         color: Colors.blue,
//   //         borderRadius: BorderRadius.circular(30),
//   //       ),
//   //       child: Icon(
//   //         Icons.add,
//   //         color: Colors.white,
//   //         size: 40,
//   //       ),
//   //     ),
//   //   );
//   // }
// }
