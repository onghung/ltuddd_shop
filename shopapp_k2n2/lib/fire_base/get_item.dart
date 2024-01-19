import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled15/constants.dart';

int tongquy=0;

class getItem extends StatelessWidget {
  final String link;
  final String kei;
  const getItem({Key? key, required this.link, required this.kei}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(link)
          .snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = streamSnapshot.data;
        int t= documents?.docs[0][kei];
        tongquy=t;
        return Text(
            NumberFormat.simpleCurrency(locale: 'vi_VN').format(t),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 25),
            );
      },
    );
  }
}
