import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import '../../constants.dart';
import 'components/donhang.dart';
import 'components/finalcial.dart';
import 'components/report.dart';

class HomeAdm extends StatefulWidget {
  HomeAdm({Key? key}) : super(key: key);

  @override
  State<HomeAdm> createState() => _HomeAdmState();
}

class _HomeAdmState extends State<HomeAdm> {
  List<Financial> expensesData = [];

  List<Financial> revenueData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('/ltuddd/5I19DY1GyC83pHREVndb/cart')
          .where('status', isEqualTo: '3')
          .get();

      // Clear existing data
      revenueData.clear();

      // Create a map to store the total count for each id
      Map<String, int> idToTotalCount = {};

      for (var doc in snapshot.docs) {
        String id = doc['id'];
        int count = doc['count'] ?? 0;
        Color color = getColorFromData(doc);

        Financial financial = Financial(id, count, color);

        // Update the total count for each id
        idToTotalCount[id] = (idToTotalCount[id] ?? 0) + count;

        // Add the financial object to the list
        revenueData.add(financial);
      }

      // Now revenueData contains the Financial objects, each with the total count for the corresponding id

      setState(() {}); // Trigger a rebuild after data is fetched
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
    }
  }

  Color getColorFromData(QueryDocumentSnapshot doc) {
    // Implement your logic to determine the color based on the data
    // For example, you can return greenColor for expenses and purpleColor for revenue.
    return  purpleColor;
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Financial, String>> expensesAndRevenueSeries = [
      charts.Series(
        id: "Đơn hàng",
        data: revenueData,
        domainFn: (Financial pops, _) => pops.id,
        measureFn: (Financial pops, _) => pops.value,
        colorFn: (Financial pops, __) =>
            charts.ColorUtil.fromDartColor(pops.barColor),
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.grey.shade200,
        title: const Text(
          "Báo cáo doanh thu",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),

            // Row for displaying "Tổng doanh thu"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<int>(
                  future: calculateTotalPricelast(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    int totalPricelast = snapshot.data ?? 0;
                    return report(totalPricelast: totalPricelast);
                  },
                ),

                const SizedBox(width: 25),

                // Row for displaying "Tổng đơn hàng"
                FutureBuilder<int>(
                  future: calculateTotalCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    int totalCount = snapshot.data ?? 0;
                    return donhang(totalCount: totalCount);
                  },
                ),
              ],
            ),

            const SizedBox(height: 45),

            // Container for the BarChart
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    offset: Offset(2, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: charts.BarChart(
                  expensesAndRevenueSeries,
                  animate: true,
                  defaultRenderer: charts.BarRendererConfig(
                    cornerStrategy: const charts.ConstCornerStrategy(40),
                  ),
                  primaryMeasureAxis: const charts.NumericAxisSpec(
                    tickProviderSpec: charts.BasicNumericTickProviderSpec(
                      desiredTickCount: 7,
                    ),
                  ),
                  behaviors: [charts.SeriesLegend()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> calculateTotalPricelast() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance
        .collection('/ltuddd/5I19DY1GyC83pHREVndb/cart')
        .where('status', isEqualTo: '3')
        .get();

    int totalPricelast = snapshot.docs
        .map((doc) => (doc['pricelast'] ?? 0) as int)
        .fold(0, (prev, curr) => prev + curr);

    return totalPricelast;
  }

  Future<int> calculateTotalCount() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance
        .collection('/ltuddd/5I19DY1GyC83pHREVndb/cart')
        .where('status', isEqualTo: '3')
        .get();

    int totalCount = snapshot.docs
        .map((doc) => (doc['count'] ?? 0) as int)
        .fold(0, (prev, curr) => prev + curr);

    return totalCount;
  }
}





