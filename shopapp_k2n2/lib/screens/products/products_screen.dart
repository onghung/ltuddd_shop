import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled15/components/product_card.dart';

import '../details/details_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key});

  static String routeName = "/products";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/ltuddd/5I19DY1GyC83pHREVndb/Product')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var documents = snapshot.data?.docs;

              return GridView.builder(
                itemCount: documents?.length ?? 0,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  // Use ProductCard widget to display each product
                  return ProductCard(
                    width: 140,
                    aspectRetio: 1.04,
                    productId: documents?[index]['id'],
                    title: documents?[index]['title'],
                    description: documents?[index]['description'],
                    rating: documents?[index]['rating'],
                    price: documents?[index]['price'],
                    isFavourite: documents?[index]['isFavourite'],
                    imageUrl: documents?[index]['imageUrl'],
                    onPress: () {
                      // Handle the onTap event
                    },
                    collectionId: documents?[index].id ?? '',
                  );
                },
              );
            },
          ),
        ),
        ),
      );
  }
}
