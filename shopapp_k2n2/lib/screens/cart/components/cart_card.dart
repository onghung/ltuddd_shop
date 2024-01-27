import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components/rounded_icon_btn.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.productId,
    required this.title,
    required this.description,
    required this.count,
    required this.rating,
    required this.price,
    required this.isFavourite,
    required this.imageUrl,
    required this.collectionId,
    required this.onIncrease,
    required this.onDecrease,
  }) : super(key: key);

  final String productId, title, description;
  final int rating, price, count;
  final bool isFavourite;
  final String imageUrl;
  final String collectionId;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  void _increaseCount() {
    onIncrease();
  }

  void _decreaseCount() {
    onDecrease();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: double.infinity),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price*count)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red, // Thay đổi màu sắc theo ý muốn
                        ),
                      ),
                    ),
                    const Spacer(),
                    RoundedIconBtn(
                      icon: Icons.remove,
                      press: _decreaseCount,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      " $count ",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(width: 20),
                    RoundedIconBtn(
                      icon: Icons.add,
                      showShadow: true,
                      press: _increaseCount,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
