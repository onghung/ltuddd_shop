import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/check_out_card.dart';
import 'components/cart_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int totalQuantity = 0;
  int totalCost = 0;


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              "Your Cart",
              style: TextStyle(color: Colors.black),
            ),
            FutureBuilder<num>(
              future: calculateTotalQuantity(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  totalQuantity = snapshot.data!.toInt() ?? 0;
                  return Text(
                    "$totalQuantity sản phẩm",
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('/ltuddd/5I19DY1GyC83pHREVndb/cart')
            .where('user', isEqualTo: user?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> cartItems = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Dismissible(
                  key: Key(cartItems[index].id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    await FirebaseFirestore.instance
                        .collection('/ltuddd/5I19DY1GyC83pHREVndb/cart')
                        .doc(cartItems[index].id)
                        .delete();

                    setState(() {
                    });
                  },
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE6E6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Spacer(),
                        SvgPicture.asset("assets/icons/Trash.svg"),
                      ],
                    ),
                  ),
                  child: CartCard(
                    price: cartItems[index]['price'] ?? 0,
                    productId: cartItems[index]['id'] ?? '',
                    title: cartItems[index]['title'] ?? '',
                    description: cartItems[index]['description'] ?? '',
                    rating: cartItems[index]['rating'] ?? 0,
                    isFavourite: cartItems[index]['isFavourite'] ?? false,
                    imageUrl: cartItems[index]['imageUrl'] ?? '',
                    collectionId: cartItems[index].id,
                    count: cartItems[index]['count'] ?? 0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<num>(
        future: calculateTotalCost(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            totalCost = snapshot.data!.toInt() ?? 0;
            return CheckoutCard(totalCost: totalCost);
          }
        },
      ),
    );
  }

  Future<num> calculateTotalQuantity() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('/ltuddd/5I19DY1GyC83pHREVndb/cart')
        .where('user', isEqualTo: user?.email)
        .get();

    num total = 0;

    for (var doc in snapshot.docs) {
      total = total + (doc['count'] ?? 0);
    }

    return total;
  }

  Future<num> calculateTotalCost() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('/ltuddd/5I19DY1GyC83pHREVndb/cart')
        .where('user', isEqualTo: user?.email)
        .get();

    num total = 0;

    for (var doc in snapshot.docs) {
      total = total+ (doc['count'] ?? 0) * (doc['price'] ?? 0);
    }

    return total;
  }
}
