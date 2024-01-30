import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../screens/details/details_screen.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
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

class _ProductCardState extends State<ProductCard> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.isFavourite;
  }

  void _toggleFavorite() async {
    setState(() {
      isFavourite = !isFavourite;
    });

    try {
      // Update isFavourite state on Firestore
      await FirebaseFirestore.instance
          .collection('/ltuddd/5I19DY1GyC83pHREVndb/Product/')
          .doc(widget.collectionId)
          .update({'isFavourite': isFavourite});
    } catch (e) {
      print('Error updating isFavourite on Firestore: $e');
      // Handle the error appropriately
    }
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
              builder: (context) => DetailsScreen(
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
                  NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(widget.price),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: _toggleFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: isFavourite
                          ? Colors.blue.withOpacity(0.15)
                          : Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Semantics(
                      label: isFavourite
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      child: SvgPicture.asset(
                        "assets/icons/Heart Icon_2.svg",
                        colorFilter: ColorFilter.mode(
                          isFavourite
                              ? const Color(0xFFFF4848)
                              : const Color(0xFFDBDEE4),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
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
