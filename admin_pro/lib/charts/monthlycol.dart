import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Map<int, String> month = {
  1: "Jan",
  2: "Feb",
  3: "Mar",
  4: "Apr",
  5: "May",
  6: "Jun",
  7: "Jul",
  8: "Aug",
  9: "Sep",
  10: "Oct",
  11: "Nov",
  12: "Dec"
};

class Collection {
  final int month;
  final int amount;

  Collection(this.month, this.amount);
}

class MonthlyCollections extends StatefulWidget {
  MonthlyCollections({Key key}) : super(key: key);

  @override
  _MonthlyCollectionsState createState() => _MonthlyCollectionsState();
}

class _MonthlyCollectionsState extends State<MonthlyCollections> {
  List<Collection> coll = List();
  Map<int, int> m = Map();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("assignments").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            m.clear();
            for (DocumentSnapshot doc in snapshot.data.docs) {
              if (m[doc['assigned_date'].toDate().month] == null) {
                m[doc['assigned_date'].toDate().month] = doc['price'];
              } else {
                m[doc['assigned_date'].toDate().month] += doc['price'];
              }
            }
            coll.clear();
            m.forEach((key, value) {
              coll.add(Collection(key, value));
            });
            print(coll);
            return SfCartesianChart(
                title: ChartTitle(text: 'Monthly Collections'),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                zoomPanBehavior: ZoomPanBehavior(
                    // Enables pinch zooming
                    enablePinching: true,
                    enableDoubleTapZooming: true),
                //  tooltipBehavior: TooltipBehavior(
                //   enable: true,
                //   format: 'point.x point.y\$'
                // ),
                trackballBehavior: TrackballBehavior(
                    // Enables the trackball
                    enable: true,
                    tooltipSettings: InteractiveTooltip(
                        enable: true,
                        color: Colors.red,
                        format: 'point.x : point.y \$')),
                series: <ChartSeries>[
                  // Renders bar chart
                  ColumnSeries<Collection, String>(
                    dataSource: coll,
                    xValueMapper: (Collection s, _) => month[s.month],
                    yValueMapper: (Collection s, _) => s.amount,
                  )
                ]);
          }),
    );
  }
}
