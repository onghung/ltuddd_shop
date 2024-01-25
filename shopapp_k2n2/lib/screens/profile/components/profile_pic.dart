import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      // Async function to get the user's image URL from Firebase
      future: _getUserImageURL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return default User Icon while waiting for the result
          return _buildProfilePicWidget("assets/icons/User Icon.svg");
        } else if (snapshot.hasError) {
          // Handle errors
          return _buildProfilePicWidget("assets/icons/User Icon.svg");
        } else {
          // Check if the user has an image URL
          String? imageUrl = snapshot.data;
          if (imageUrl != null && imageUrl.isNotEmpty) {
            // Return CircleAvatar with Firebase image URL
            return CircleAvatar(
              radius: 57, // 115 / 2
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 55, // Slightly smaller to add a border
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(imageUrl),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: _buildCameraButton(),
                ),
              ),
            );
          } else {
            // Return default User Icon if there is no Firebase image URL
            return _buildProfilePicWidget("assets/icons/User Icon.svg");
          }
        }
      },
    );
  }

  // Function to get the user's image URL from Firebase
  Future<String> _getUserImageURL() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('/ltuddd/5I19DY1GyC83pHREVndb/avatar')
          .where('user', isEqualTo: user.email)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        // User has an image URL in Firestore
        return result.docs.first['imageUrl'];
      } else {
        // User does not have an image URL in Firestore
        return "";
      }
    }
    return "";
  }

  // Function to build the ProfilePic widget
  Widget _buildProfilePicWidget(String defaultImage) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(defaultImage),
          Positioned(
            right: -16,
            bottom: 0,
            child: _buildCameraButton(),
          ),
        ],
      ),
    );
  }

  // Function to build the camera button
  Widget _buildCameraButton() {
    return SizedBox(
      height: 46,
      width: 46,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: () => _openCamera(context),
        child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
      ),
    );
  }

  // Function to open the camera and update the user's image on Firebase
// Function to open the camera and update the user's image on Firebase
  Future<void> _openCamera(BuildContext context) async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      // Lấy người dùng hiện tại
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Kiểm tra xem người dùng đã có ảnh trên Firebase hay chưa
        QuerySnapshot result = await FirebaseFirestore.instance
            .collection('/ltuddd/5I19DY1GyC83pHREVndb/avatar')
            .where('user', isEqualTo: user.email)
            .limit(1)
            .get();

        if (result.docs.isNotEmpty) {
          // Lấy thông tin về ảnh cũ
          String oldImageUrl = result.docs.first['imageUrl'];

          // Xóa ảnh cũ trên Firebase Storage
          await firebase_storage.FirebaseStorage.instance.refFromURL(oldImageUrl).delete();

          // Tạo thư mục lưu trữ Firebase cho ảnh mới
          firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('/img/avatar${DateTime.now().millisecondsSinceEpoch}.png');

          // Tải ảnh mới lên Firebase Storage
          await storageRef.putFile(File(image.path));

          // Lấy URL của ảnh mới đã tải lên
          String downloadURL = await storageRef.getDownloadURL();

          // Update thông tin vào Firestore với ảnh mới
          FirebaseFirestore.instance
              .collection('/ltuddd/5I19DY1GyC83pHREVndb/avatar')
              .doc(result.docs.first.id)
              .update({'imageUrl': downloadURL});
        } else {
          // Thêm thông tin vào Firestore nếu người dùng chưa có ảnh
          firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('img/${DateTime.now().millisecondsSinceEpoch}.png');

          // Tải ảnh mới lên Firebase Storage
          await storageRef.putFile(File(image.path));

          // Lấy URL của ảnh mới đã tải lên
          String downloadURL = await storageRef.getDownloadURL();

          // Thêm thông tin vào Firestore với ảnh mới
          FirebaseFirestore.instance
              .collection('/ltuddd/5I19DY1GyC83pHREVndb/avatar')
              .add({'user': user.email, 'imageUrl': downloadURL});
        }
      }
    }
  }
}
