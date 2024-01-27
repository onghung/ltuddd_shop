import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../components/themed_products.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Chủ đề",
            press: () {},
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FutureBuilder<int>(
                future: countProducts('device'), // Đếm số lượng sản phẩm với 'seri'='device'
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    int numOfDeviceProducts = snapshot.data ?? 0;
                    return SpecialOfferCard(
                      image: "assets/images/Image Banner 2.png",
                      category: "Device",
                      numOfBrands: numOfDeviceProducts,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ThemedProducts(seri: 'device'),
                          ),
                        );

                      },
                    );
                  }
                },
              ),
              FutureBuilder<int>(
                future: countProducts('fashion'), // Đếm số lượng sản phẩm với 'seri'='fashion'
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    int numOfFashionProducts = snapshot.data ?? 0;
                    return SpecialOfferCard(
                      image: "assets/images/Image Banner 3.png",
                      category: "Fashion",
                      numOfBrands: numOfFashionProducts,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ThemedProducts(seri: 'fashion'),
                          ),
                        );

                      },
                    );
                  }
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }

  Future<int> countProducts(String seri) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('/ltuddd/5I19DY1GyC83pHREVndb/Product')
        .where('seri', isEqualTo: seri)
        .get();

    return snapshot.size;
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 242,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.black38,
                        Colors.black26,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfBrands Sản phẩm")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
