// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_hl_vnpay/flutter_hl_vnpay.dart';
// import 'package:crypto/crypto.dart';
//
//
// class MyPaymentPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('VNPAY Flutter Example'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   _onBuyCoinPressed(context);
//                 },
//                 child: Text('Thanh toán 10.000 VND'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _onBuyCoinPressed(BuildContext context) async {
//     try {
//       String url = 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';
//       String tmnCode = 'W8QQLCLB'; // Get from VNPay
//       String hashKey = 'AOKCGPBQYITYRWYLPTZSAXYYCWRZVZZF'; // Get from VNPay
//
//       final params = <String, dynamic>{
//         'vnp_Command': 'pay',
//         'vnp_Amount': '3000000',
//         'vnp_CreateDate': '20210315151908',
//         'vnp_CurrCode': 'VND',
//         'vnp_IpAddr': '192.168.15.102',
//         'vnp_Locale': 'vn',
//         'vnp_OrderInfo': '5fa66b8b5f376a000417e501 pay coin 30000 VND',
//         'vnp_ReturnUrl': 'https://hl-solutions.vercel.app/orders/order-return',
//         'vnp_TmnCode': tmnCode,
//         'vnp_TxnRef': DateTime.now().millisecondsSinceEpoch.toString(),
//         'vnp_Version': '2.0.0'
//       };
//
//       final sortedParams = FlutterHlVnpay.instance.sortParams(params);
//       final hashData = sortedParams.entries.map((e) => '${e.key}=${e.value}').join('&');
//       var bytes = utf8.encode('$hashKey$hashData');
//       final vnpSecureHash = sha256.convert(bytes);
//
//       final query = Uri(queryParameters: sortedParams).query;
//       final paymentUrl = "$url?$query&vnp_SecureHashType=SHA256&vnp_SecureHash=$vnpSecureHash";
//
//       print('paymentUrl = $paymentUrl');
//
//       final result = await FlutterHlVnpay.instance.show(
//         paymentUrl: paymentUrl,
//         tmnCode: tmnCode,
//         scheme: 'hlsolutions',
//       );
//
//       print('Payment Result Code: $result');
//     } on PlatformException catch (e) {
//       print('PlatformException: $e');
//     } catch (e) {
//       print('Exception: $e');
//     }
//   }
// }
