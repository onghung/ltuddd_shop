import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../screens/details/details_screen.dart';
import 'detail_product_admin.dart';

class ProductCard_adm extends StatefulWidget {
  const ProductCard_adm({
    Key? key,
    this.width = 140.0,
    this.aspectRetio = 1.2,
    required this.productId,
    required this.title,
    required this.description,
    required this.rating,
    required this.price,
    required this.isFavourite,
    required this.imageUrl,
    required this.onPress,
    required this.collectionId,
  }) : super(key: key);

  final double width, aspectRetio;
  final String productId, title, description;
  final int rating, price;
  final bool isFavourite;
  final String imageUrl;
  final String collectionId;
  final VoidCallback onPress;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard_adm> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: InkWell(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailAdm(
                productId: widget.productId,
                title: widget.title,
                description: widget.description,
                rating: widget.rating,
                price: widget.price,
                isFavourite: widget.isFavourite,
                imageUrl: widget.imageUrl,
                collectionId: widget.collectionId,
              ),
            ),
          )
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: widget.aspectRetio,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: widget.imageUrl.isNotEmpty
                    ? Image.network(
                        widget.imageUrl,
                        fit: BoxFit.fill,
                      )
                    : Placeholder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                      .format(widget.price),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    height: 24,
                    width: 24,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
