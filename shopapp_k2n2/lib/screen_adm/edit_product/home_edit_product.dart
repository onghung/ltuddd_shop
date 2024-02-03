import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'components/add_product.dart';
import 'components/product_card_adm.dart';

class EdiProduct extends StatelessWidget {
  const EdiProduct({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Danh sách sản phẩm",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
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
                        return ProductCard_adm(
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddProductPage and wait for result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );

          // Handle the result if needed
          if (result != null) {
            // Handle the result from AddProductPage
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
