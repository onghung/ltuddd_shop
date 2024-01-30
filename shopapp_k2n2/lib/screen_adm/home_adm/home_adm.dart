import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomeAdm extends StatelessWidget {
  const HomeAdm({Key? key}) : super(key: key);
  static final greenColor = Color(0xFFF39C3AD);
  static final purpleColor = Color(0xFFF6351CB);

  static final List<Financial> expensesData = [
    Financial('2014', 5, greenColor),
    Financial('2015', 25, greenColor),
    Financial('2016', 100, greenColor),
    Financial('2018', 50, greenColor),
    Financial('2019', 25, greenColor),
  ];
  static final List<Financial> revenueData = [
    Financial('2014', 7, purpleColor),
    Financial('2015', 29, purpleColor),
    Financial('2016', 120, purpleColor),
    Financial('2018', 40, purpleColor),
    Financial('2019', 55, purpleColor),
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Financial, String>> expensesAndRevenueSeries = [
      charts.Series(
        id: "Expenses",
        data: expensesData,
        domainFn: (Financial pops, _) => pops.year,
        measureFn: (Financial pops, _) => pops.value,
        colorFn: (Financial pops, __) =>
            charts.ColorUtil.fromDartColor(pops.barColor),
      ),
      charts.Series(
        id: "Revenue",
        data: revenueData,
        domainFn: (Financial pops, _) => pops.year,
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
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: 155,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: greenColor.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ], color: greenColor, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: const [
                    Text(
                      "2022",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text("Total Revenue",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text("(in millions)",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("\$20",
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: 155,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: purpleColor.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ], color: purpleColor, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: const [
                    Text(
                      "2022",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text("Total Profit",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text("(in millions)",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("\$2",
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 45,
          ),
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
                      offset: Offset(2, 3)),
                ]),
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
    );
  }
}

class Financial {
  final String year;
  final int value;
  final Color barColor;

  Financial(this.year, this.value, this.barColor);
}
