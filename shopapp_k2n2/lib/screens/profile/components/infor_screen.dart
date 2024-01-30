import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalInfoWidget extends StatefulWidget {
  @override
  _PersonalInfoWidgetState createState() => _PersonalInfoWidgetState();
}

class _PersonalInfoWidgetState extends State<PersonalInfoWidget> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController addressController;
  late TextEditingController contactController;

  late String originalName;
  late String originalAge;
  late String originalAddress;
  late String originalContact;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty values
    nameController = TextEditingController();
    ageController = TextEditingController();
    addressController = TextEditingController();
    contactController = TextEditingController();
    // Fetch personal information from Firestore
    fetchPersonalInfo();
  }

  void fetchPersonalInfo() async {
    try {
      // Replace '/ltuddd/5I19DY1GyC83pHREVndb/account' with your actual Firestore path
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('/ltuddd/5I19DY1GyC83pHREVndb/account')
          .limit(1) // Limit to the first document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve data from the first document
        DocumentSnapshot<Map<String, dynamic>> snapshot = querySnapshot.docs.first;
        setState(() {
          nameController.text = snapshot['name'] ?? 'N/A';
          ageController.text = snapshot['age'] ?? 'N/A';
          addressController.text = snapshot['address'] ?? 'N/A';
          contactController.text = snapshot['contact'] ?? 'N/A';

          // Save the original values for comparison
          originalName = snapshot['name'] ?? 'N/A';
          originalAge = snapshot['age'] ?? 'N/A';
          originalAddress = snapshot['address'] ?? 'N/A';
          originalContact = snapshot['contact'] ?? 'N/A';
        });
      } else {
        print('No documents found');
        // Handle the case where no documents are found
      }
    } catch (e) {
      print('Error fetching personal informatio: $e');
      // Handle the error appropriately
    }
  }

  void updatePersonalInfo() async {
    try {
      // Replace '/ltuddd/5I19DY1GyC83pHREVndb/account' with your actual Firestore path
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('/ltuddd/5I19DY1GyC83pHREVndb/account')
          .where('name', isEqualTo: originalName)  // Assuming 'name' is unique and won't change
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> snapshot = querySnapshot.docs.first;
        String documentId = snapshot.id;

        await FirebaseFirestore.instance
            .collection('/ltuddd/5I19DY1GyC83pHREVndb/account')
            .doc(documentId)
            .update({
          'name': nameController.text,
          'age': ageController.text,
          'address': addressController.text,
          'contact': contactController.text,
        });

        // Update the original values after successful update
        setState(() {
          originalName = nameController.text;
          originalAge = ageController.text;
          originalAddress = addressController.text;
          originalContact = contactController.text;
        });

        // Show a success message or perform any other actions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thông tin đã được cập nhật thành công!'),
          ),
        );
      } else {
        // Handle the case where the document does not exist
        print('Document does not exist');
      }
    } catch (e) {
      print('Error updating personal information: $e');
      // Handle the error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Name', nameController, Icons.person),
              _buildInfoRow('Age', ageController, Icons.cake),
              _buildInfoRow('Address', addressController, Icons.location_on),
              _buildInfoRow('Contact', contactController, Icons.phone),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_isInfoChanged()) {
                    Navigator.pop(context);
                    updatePersonalInfo();
                  } else {
                    // Show a message indicating that no changes were made
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Không có thay đổi để cập nhật!'),
                      ),
                    );
                  }
                },
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
          TextField(
            controller: controller,
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

  bool _isInfoChanged() {
    // Compare current values with original values
    return nameController.text != originalName ||
        ageController.text != originalAge ||
        addressController.text != originalAddress ||
        contactController.text != originalContact;
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    ageController.dispose();
    addressController.dispose();
    contactController.dispose();
    super.dispose();
  }
}
