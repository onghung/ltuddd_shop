import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class CheckoutCard extends StatefulWidget {
   CheckoutCard({
    Key? key,
    required this.totalCost,
  }) : super(key: key);

  int totalCost;

  @override
  _CheckoutCardState createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  int _selectedVoucherIndex = -1;
  List<int> discountAmounts = [100000, 150000]; // Discount amounts for each voucher

  @override
  Widget build(BuildContext context) {
    final formattedTotalCost = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(widget.totalCost);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset("assets/icons/receipt.svg"),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _showVoucherList(context); // Function to show voucher list
                  },
                  child: const Text("Add voucher code"),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "Tổng:\n",
                      children: [
                        TextSpan(
                          text: formattedTotalCost,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Check Out"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showVoucherList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            _buildVoucherTile(0, 'Voucher 1: giảm 100k giá trị đơn hàng'),
            _buildVoucherTile(1, 'Voucher 2: giảm 150k giá trị đơn hàng'),
          ],
        );
      },
    );
  }

  ListTile _buildVoucherTile(int index, String title) {
    bool isSelected = _selectedVoucherIndex == index;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.green : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        _selectVoucher(index, discountAmounts[index]);
      },
    );
  }

  void _selectVoucher(int index, int discountAmount) {
    if (_selectedVoucherIndex == index) {
      // If the same voucher is clicked again, reset the selection
      setState(() {
        _selectedVoucherIndex = -1;
        // Add back the discount to the totalCost
        widget.totalCost += discountAmount;
      });
    } else {
      setState(() {
        _selectedVoucherIndex = index;
        // Deduct the discount from the totalCost
        widget.totalCost -= discountAmount;
      });
    }

    Navigator.pop(context); // Close the voucher list bottom sheet
  }

}
