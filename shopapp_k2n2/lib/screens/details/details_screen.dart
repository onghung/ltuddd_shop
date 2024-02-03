import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../cart/cart_screen.dart';
import 'components/color_dots.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  const DetailsScreen({
    Key? key,
    required this.productId,
    required this.title,
    required this.description,
    required this.rating,
    required this.price,
    required this.isFavourite,
    required this.imageUrl,
    required this.collectionId,
  }) : super(key: key);

  final String productId, title, description;
  final int rating, price;
  final bool isFavourite;
  final String imageUrl;
  final String collectionId;

  Future<void> _addCart(quantity) async {
    final user = FirebaseAuth.instance.currentUser!;
    final cartRef = FirebaseFirestore.instance.collection('/ltuddd/5I19DY1GyC83pHREVndb/cart');

    try {
      // Kiểm tra xem đã có cart của người dùng với "id" đã cho hay chư
      final existingCart = await cartRef
          .where('user', isEqualTo: user?.email)
          .where('id', isEqualTo: productId)
          .get();

      if (existingCart.docs.isEmpty) {
        await cartRef.add({
          'user': user?.email,
          'imageUrl': imageUrl,
          'description': description,
          'id': productId,
          'price': price,
          'title': title,
          'count': quantity,
          'rating': 4,
          'isFavourite': true,
          'status':'1'

        });

        print('Image added to Firestore with URL: ${imageUrl}');
      } else if(existingCart.docs.first['status'] != '1'){
        await cartRef.add({
          'user': user?.email,
          'imageUrl': imageUrl,
          'description': description,
          'id': productId,
          'price': price,
          'title': title,
          'count': quantity,
          'rating': 4,
          'isFavourite': true,
          'status':'1'

        });

        print('Image added to Firestore with URL: ${imageUrl}');
      }else {
        final cartDocId = existingCart.docs.first.id;
        final existingCount = existingCart.docs.first['count'] ?? 0;
        await cartRef.doc(cartDocId).update({'count': existingCount + quantity});

        print('Increased count for the product in the cart');
      }
    } catch (e) {
      print('Error adding image to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                     Text(
                      '$rating',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset("assets/icons/Star Icon.svg"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          ProductImages(Url: imageUrl ),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(
                  descrip: description,
                  title: title,
                  pressOnSeeMore: () {},
                ),
                const TopRoundedContainer(
                  color: Color(0xFFF6F7F9),
                  child: Column(
                    children: [
                      ColorDots(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ElevatedButton(
              onPressed: () {
                _addCart(1);
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              child: const Text("Add To Cart"),
            ),
          ),
        ),
      ),
    );
  }
}
