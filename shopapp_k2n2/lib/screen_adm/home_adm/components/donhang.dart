import 'package:flutter/material.dart';

import '../../../constants.dart';

class donhang extends StatelessWidget {
  const donhang({
    super.key,
    required this.totalCount,
  });

  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: 155,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: purpleColor.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
        color: purpleColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            "2024",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          SizedBox(height: 6),
          Text(
            "Tổng đơn hàng",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            "(sản phẩm)",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            "$totalCount",
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
