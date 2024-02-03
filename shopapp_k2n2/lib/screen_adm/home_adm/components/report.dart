import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class report extends StatelessWidget {
  const report({
    super.key,
    required this.totalPricelast,
  });

  final int totalPricelast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: 155,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: greenColor.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
        color: greenColor,
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
            "Tổng doanh thu",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            "(triệu)",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            "${NumberFormat.simpleCurrency(decimalDigits: 2).format(totalPricelast / 1000000)}",
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
