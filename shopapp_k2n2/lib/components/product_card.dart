import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140.0,
    this.aspectRetio = 1.8,
    required this.productId,
    required this.title,
    required this.description,
    required this.rating,
    required this.price,
    required this.isFavourite,
    required this.imageUrl,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final String productId, title, description;
  final int rating, price;
  final bool isFavourite;
  final String imageUrl;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: aspectRetio,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                )
                    : Placeholder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${price.toString()}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue, // Your desired color
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {},
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
                      label: isFavourite ? 'Remove from favorites' : 'Add to favorites',
                      child: SvgPicture.asset(
                        "assets/icons/Heart Icon_2.svg",
                        colorFilter: ColorFilter.mode(
                          isFavourite ? const Color(0xFFFF4848) : const Color(0xFFDBDEE4),
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

class ProductGrid extends StatelessWidget {
  final List<ProductCard> products;

  ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return products[index];
      },
    );
  }
}
