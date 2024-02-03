import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController seriController = TextEditingController();
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Sản Phẩm Mới'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Title', titleController, Icons.title),
              _buildInfoRow('Description', descriptionController, Icons.description),
              _buildInfoRow('Rating', ratingController, Icons.star),
              _buildInfoRow('Price', priceController, Icons.attach_money),
              _buildInfoRow('ID', idController, Icons.confirmation_number),
              _buildInfoRow('Seri', seriController, Icons.confirmation_number),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _showImageOptions();
                },
                child: Text('Chọn ảnh'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _addProductToDatabase();
                },
                child: Text('Thêm Sản Phẩm'),
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

  Future<void> _addProductToDatabase() async {
    try {
      String productImageUrl = imageUrl ?? ''; // Set default value if imageUrl is null

      await FirebaseFirestore.instance.collection('/ltuddd/5I19DY1GyC83pHREVndb/Product').add({
        'title': titleController.text,
        'description': descriptionController.text,
        'rating': int.tryParse(ratingController.text) ?? 0,
        'price': int.tryParse(priceController.text) ?? 0,
        'id': idController.text,
        'seri': seriController.text,
        'imageUrl': productImageUrl,
        'isFavourite': false,
        // ... (any other fields needed)
      });

      // After adding the product, you can navigate back to the previous screen or perform any other actions.
      Navigator.pop(context);
    } catch (e) {
      print('Error adding product to Firestore: $e');
      // Handle error, show a message, or perform any other necessary actions
    }
  }

  Future<void> _showImageOptions() async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Open Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    await _uploadImageToStorage(image);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Open Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (image != null) {
                    await _uploadImageToStorage(image);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImageToStorage(XFile image) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('img/product/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');

      UploadTask uploadTask = storageReference.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      setState(() {
        imageUrl = taskSnapshot.ref.getDownloadURL() as String?;
      });
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      // Handle error, show a message, or perform any other necessary actions
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    ratingController.dispose();
    priceController.dispose();
    idController.dispose();
    seriController.dispose();
    super.dispose();
  }
}
