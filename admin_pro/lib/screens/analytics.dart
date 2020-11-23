import 'package:flutter/material.dart';
import 'package:admin_pro/charts/dailycol.dart';
import 'package:admin_pro/charts/monthlycol.dart';
import 'package:admin_pro/charts/weekly.dart';

class Analytics extends StatefulWidget {
  Analytics({Key key}) : super(key: key);

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 20.0,
      radius: Radius.circular(10.0),
          child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(border: Border.all(),
                borderRadius: BorderRadius.circular(10)
                ),
                child: DailiCollections(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(border: Border.all(),
                borderRadius: BorderRadius.circular(10)
                ),
                child: Weekly(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(border: Border.all(),
                borderRadius: BorderRadius.circular(10)
                ),
                child: MonthlyCollections(),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
