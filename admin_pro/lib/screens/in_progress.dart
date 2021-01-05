import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:intl/intl.dart';
import 'package:admin_pro/widgets/task_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

// FirebaseApp secondaryApp = Firebase.app('adminpro');
// FirebaseFirestore firestore = FirebaseFirestore.instanceFor(app: secondaryApp);

// class InProgress extends StatelessWidget {
//   const InProgress({Key key}) : super(key: key);

// }

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}

DateTime firstDay(DateTime d){

  //DateTime n = DateTime.now();
  String month = d.month>9?"${d.month}":"0${d.month}";
  String day = d.day>9?"${d.day}":"0${d.day}";

  DateTime newd = DateTime.parse("${d.year}-" + month +"-"+ day + " 00:00:00Z");
  return newd.subtract(new Duration(days: d.weekday));
}

DateTime  lastDay(DateTime d){
  String month = d.month>9?"${d.month}":"0${d.month}";
  String day = d.day>9?"${d.day}":"0${d.day}";

  DateTime newd = DateTime.parse("${d.year}-" + month +"-"+ day + " 00:00:00Z");

  //DateTime newd = DateTime.parse("${d.year}-${d.month}-${d.day} 00:00:00Z");
  return newd.add(new Duration(days: 7-d.weekday));
}

class InProgress extends StatefulWidget {
  InProgress({Key key}) : super(key: key);

  @override
  _InProgressState createState() => _InProgressState();
}

class _InProgressState extends State<InProgress> {


  Widget _buildListItem(
    BuildContext context,
    DocumentSnapshot doc,
  ) {
    print(doc['student']);
    return TaskContainer(
      title: doc['student'],
      subtitle: "Due " + doc['due_date'].toDate().toString(),
      boxColor: LightColors.kLightYellow2,
      price: doc['price'],
      tutor: doc['tutor'],
      id: doc.id,
      // a:assignments[index]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
