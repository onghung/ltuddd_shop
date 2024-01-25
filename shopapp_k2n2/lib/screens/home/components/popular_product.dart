import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../components/product_card.dart';
import '../../../constants.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({Key? key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Sản phẩm phổ biến",
            press: () {
              Navigator.pushNamed(context, ProductsScreen.routeName);
            },
          ),
        ),
        SizedBox(
          height: 300,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/ltuddd/5I19DY1GyC83pHREVndb/Product')
                .snapshots(),
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documents = streamSnapshot.data;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: documents?.docs.length,
                itemBuilder: (ctx, index) {
                  // Extract information from the document
                  String productId = documents?.docs[index]['id'];
                  String title = documents?.docs[index]['title'];
                  String description = documents?.docs[index]['description'];
                  int rating = documents?.docs[index]['rating'];
                  int price = documents?.docs[index]['price'];
                  bool isFavourite = documents?.docs[index]['isFavourite'];
                  String imageUrl = documents?.docs[index]['imageUrl'];

                  return Container(
                    margin: EdgeInsets.only(left: 20),
                    child: ProductCard(
                      width: 140, // Set your desired width
                      aspectRetio: 1.02,
                      productId: productId,
                      title: title,
                      description: description,
                      rating: rating,
                      price: price,
                      isFavourite: isFavourite,
                      imageUrl: imageUrl,
                      onPress: () {
                        // Handle the onTap event
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
