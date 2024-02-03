import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'mes_adm.dart';

class UsersListScreen extends StatefulWidget {
  static String routeName = "/usersList";

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách người dùng'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('/ltuddd/5I19DY1GyC83pHREVndb/chat')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> messages = snapshot.data!.docs;
          Set<String> usersSet = Set<String>();

          for (var message in messages) {
            // Ajoutez les deux participants de la conversation à l'ensemble
            usersSet.add(message['user']);
            usersSet.add(message['contact']);
          }

          // Retirez l'utilisateur actuel de la liste s'il y est
          usersSet.remove(user.email);

          List<String> usersList = usersSet.toList();

          return ListView.builder(
            itemCount: usersList.length,
            itemBuilder: (context, index) {
              String contactEmail = usersList[index];

              return ListTile(
                title: Text(contactEmail),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreenadm(
                        contactEmail: contactEmail,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
