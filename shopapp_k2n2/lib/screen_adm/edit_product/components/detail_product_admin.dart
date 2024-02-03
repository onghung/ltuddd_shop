import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class DetailAdm extends StatefulWidget {
  final String productId;
  final String title;
  final String description;
  final int rating;
  final int price;
  final bool isFavourite;
  final String imageUrl;
  final String collectionId;

  DetailAdm({
    required this.productId,
    required this.title,
    required this.description,
    required this.rating,
    required this.price,
    required this.isFavourite,
    required this.imageUrl,
    required this.collectionId,
  });

  @override
  _DetailAdmState createState() => _DetailAdmState();
}

class _DetailAdmState extends State<DetailAdm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController ratingController;
  late TextEditingController priceController;

  late String originalTitle;
  late String originalDescription;
  late int originalRating;
  late int originalPrice;
  late String originalImageUrl;
  String updatedImageUrl = '';

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
    ratingController = TextEditingController(text: widget.rating.toString());
    priceController = TextEditingController(text: widget.price.toString());

    originalTitle = widget.title;
    originalDescription = widget.description;
    originalRating = widget.rating;
    originalPrice = widget.price;
    originalImageUrl = widget.imageUrl;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Title', titleController, Icons.title),
              _buildInfoRow('Description', descriptionController, Icons.description),
              _buildInfoRow('Rating', ratingController, Icons.star),
              _buildInfoRow('Price', priceController, Icons.attach_money),
              _buildImageRow(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _validateAndUpdate,
                child: Text('Cập nhật thông tin'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập $label';
              }
              return null;
            },
            onChanged: (_) {
              // Handle text changes if needed
            },
            decoration: InputDecoration(
              suffixIcon: Icon(
                icon,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageRow() {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Image.network(
            originalImageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        InkWell(
          child: const Text(
            "Thay đổi",
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: () => _showImagePickerOptions(context),
        )
      ],
    );
  }

  void _validateAndUpdate() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (_isInfoChanged()) {
        Navigator.pop(context);
        updateProductInfo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không có thay đổi để cập nhật!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  bool _isInfoChanged() {
    return titleController.text != originalTitle ||
        descriptionController.text != originalDescription ||
        int.tryParse(ratingController.text) != originalRating ||
        int.tryParse(priceController.text) != originalPrice ||
        updatedImageUrl != originalImageUrl;
  }

  Future<void> _showImagePickerOptions(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Open Gallery'),
                onTap: () {
                  _openImagePicker(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Open Camera'),
                onTap: () {
                  _openCamera(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openImagePicker(BuildContext context) async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageRef = storage.ref().child('img/product/${widget.productId}');
        await storageRef.putFile(File(image.path));
        String downloadURL = await storageRef.getDownloadURL();

        setState(() {
          updatedImageUrl = downloadURL;
        });
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageRef = storage.ref().child('img/product/${widget.productId}');
        await storageRef.putFile(File(image.path));
        String downloadURL = await storageRef.getDownloadURL();

        setState(() {
          updatedImageUrl = downloadURL;
        });
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    }
  }

  void updateProductInfo() async {
    try {
      DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore
          .instance
          .collection('/ltuddd/5I19DY1GyC83pHREVndb/Product')
          .doc(widget.collectionId);

      DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();

      if (snapshot.exists) {
        Map<String, dynamic> updatedData = {
          'title': titleController.text,
          'description': descriptionController.text,
          'rating': int.tryParse(ratingController.text) ?? 0,
          'price': int.tryParse(priceController.text) ?? 0,
          'imageUrl': updatedImageUrl,
        };

        await docRef.update(updatedData);

        setState(() {
          originalTitle = titleController.text;
          originalDescription = descriptionController.text;
          originalRating = int.tryParse(ratingController.text) ?? 0;
          originalPrice = int.tryParse(priceController.text) ?? 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thông tin đã được cập nhật thành công!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error updating product information: $e');
    }
  }
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    ratingController.dispose();
    priceController.dispose();
    super.dispose();
  }
}