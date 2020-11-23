import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Collection {
  final DateTime day;
  final int amount;

  Collection(this.day, this.amount);
}

class DailiCollections extends StatefulWidget {
  @override
  _DailiCollectionsState createState() => _DailiCollectionsState();
}

class _DailiCollectionsState extends State<DailiCollections> {
  Map<DateTime, int> m = Map();
  List<Collection> coll = List();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("assignments").snapshots(),
          builder: (context, snapshot) {
            m.clear();
            for (DocumentSnapshot doc in snapshot.data.docs) {
              if (m[doc['assigned_date'].toDate()] == null) {
                m[doc['assigned_date'].toDate()] = doc['price'];
              } else {
                m[doc['assigned_date'].toDate()] += doc['price'];
              }
            }
            coll.clear();
            m.forEach((key, value) {
              coll.add(Collection(key, value));
            });
            print(coll);
            return SfCartesianChart(
                title: ChartTitle(text: 'Daily Collections'),
                primaryXAxis: DateTimeAxis(),
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
                  ColumnSeries<Collection, DateTime>(
                    dataSource: coll,
                    xValueMapper: (Collection s, _) => s.day,
                    yValueMapper: (Collection s, _) => s.amount,
                  )
                ]);
          }),
    );
  }
}
