import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';


class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    this.pressOnSeeMore,
    required this.descrip,
    required this.title,
  }) : super(key: key);

  final String descrip;
  final String title;
  final GestureTapCallback? pressOnSeeMore;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            widget.descrip,
            maxLines: isExpanded ? null : 3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
              if (widget.pressOnSeeMore != null) {
                widget.pressOnSeeMore!();
              }
            },
            child: Row(
              children: [
                Text(
                  "Xem chi tiết",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue, // Change this to your desired color
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  isExpanded
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  size: 12,
                  color: Colors.blue, // Change this to your desired color
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
