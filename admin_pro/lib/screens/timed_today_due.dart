import 'package:flutter/material.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:admin_pro/widgets/data.dart';
import 'package:expandable/expandable.dart';
import 'package:admin_pro/widgets/task_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_pro/screens/timed_container.dart';

class TimedDueToday extends StatefulWidget {
  @override
  _TimedDueTodayState createState() => _TimedDueTodayState();
}

class _TimedDueTodayState extends State<TimedDueToday> {

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kPalePink,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  Widget _buildListItem(
      BuildContext context,
      DocumentSnapshot doc,
      ) {
    return TimedContainer(
      title: doc['student'],
      subtitle: "Due " + doc['start_date'].toDate().toString(),
      boxColor: LightColors.kPalePink,
      price: doc['price'],
      tutor: doc['tutor'],
      id: doc.id,
      // a:assignments[index]
    );
  }


  @override
  Widget build(BuildContext context) {
    CollectionReference timed =
    FirebaseFirestore.instance.collection('timed');
    DateTime n = DateTime.now();
    DateTime n1 = DateTime.parse("${n.year}-${n.month}-${n.day} 00:00:00Z");

    List<DocumentSnapshot> dc = new List();

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    Text(
                      "Due Today",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    StreamBuilder(
                      stream: timed.snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) return Text("Loading.......");

                        for (DocumentSnapshot doc
                        in snapshot.data.documents) {
                          DateTime d = doc['start_date'].toDate();
                          DateTime t = DateTime.now();
                          if (d.day == t.day &&
                              d.month == t.month &&
                              d.year == t.year && doc['satus']=='ongoing') {
                            dc.add(doc);
                          }
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: dc.length,
                          itemBuilder: (BuildContext context, int index) {

                            return _buildListItem(
                              context,
                              dc[index],
                            );
                          },
                          separatorBuilder:
                              (BuildContext context, int index) =>
                          const Divider(),
                          physics: const NeverScrollableScrollPhysics(),
                        );
                      },
                    ),

                    Divider(
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}