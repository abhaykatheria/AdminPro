import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}

DateTime getFirstDay(DateTime d){


  DateTime newd = DateTime.parse("${d.year}-${d.month}-${d.day} 00:00:00Z");
  // microsecond
  // millisecond
  // minute
return newd.subtract(new Duration(days: d.weekday));
}

class Collection {
  final DateTime day;
  final int amount;

  Collection(this.day, this.amount);
}

class Weekly extends StatefulWidget {
  Weekly({Key key}) : super(key: key);

  @override
  _WeeklyState createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
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
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            m.clear();
            for (DocumentSnapshot doc in snapshot.data.docs) {
              if (m[getFirstDay(doc['assigned_date'].toDate())] == null) {
                m[getFirstDay(doc['assigned_date'].toDate())] = doc['price'];
              } else {
                m[getFirstDay(doc['assigned_date'].toDate())] += doc['price'];
              }
            }
            coll.clear();
            m.forEach((key, value) {
              coll.add(Collection(key, value));
              print(key);
            });
            print(coll);
            return SfCartesianChart(
                title: ChartTitle(text: 'Weekly Collections'),
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
