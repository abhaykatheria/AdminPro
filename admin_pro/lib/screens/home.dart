import 'package:admin_pro/screens/timed_today_due.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:admin_pro/widgets/active_project_card.dart';
import 'package:admin_pro/widgets/task_column.dart';
import 'package:flutter/material.dart';
import 'package:admin_pro/screens/in_progress.dart';
import 'package:admin_pro/screens/done.dart';
import 'package:admin_pro/screens/past_due.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_pro/screens/all_ass.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:admin_pro/theme/decorations.dart';
import 'package:admin_pro/screens/students_view.dart';

import 'ass_today_due.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
class Student{
  final name;
  final id;

  Student(this.name, this.id);
}
Text subheading(String title) {
  return Text(
    title,
    style: TextStyle(
        color: LightColors.kDarkBlue,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2),
  );
}

class _HomeState extends State<Home> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final ValueChanged _onChanged = (val) => print(val);


  @override
  Widget build(BuildContext context) {
    CollectionReference assgs =
        FirebaseFirestore.instance.collection('assignments');
  List<String> _getTutorsList(BuildContext context, QuerySnapshot docs) {
      List<String> tutor_list = List();
      for (DocumentSnapshot doc in docs.docs) {
        tutor_list.add(doc['name']);
      }
      return tutor_list;
    }
  List<String> _getIdList(BuildContext context, QuerySnapshot docs) {
      List<String> tutor_list = List();
      for (DocumentSnapshot doc in docs.docs) {
        tutor_list.add(doc.id);
      }
      return tutor_list;
    }

    CollectionReference timed =
    FirebaseFirestore.instance.collection('timed');

  CollectionReference students =
    FirebaseFirestore.instance.collection('students');

    return Container(
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height : 15.0),
                  StreamBuilder<Object>(
                              stream: students
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Text("Loading.......");
                                List<String> students_list = _getTutorsList(context, snapshot.data);
                                List<String> id_list = _getIdList(context, snapshot.data);
                                return FormBuilderTypeAhead(
              decoration: getTextDecoration(label:"Student",prefix: ""),
              attribute: 'student',
              onChanged: _onChanged,
              itemBuilder: (context, student) {
                return ListTile(
                  title: Text(student),
                  onTap: () {
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentsView(id:id_list[students_list.indexOf(student)])));
                  },
                );
              },
              controller: TextEditingController(text: ''),
              
              suggestionsCallback: (query) {
                if (query.isNotEmpty) {
                  var lowercaseQuery = query.toLowerCase();
                  return students_list.where((student) {
                    return student.toLowerCase().contains(lowercaseQuery);
                  }).toList(growable: false)
                    ..sort((a, b) => a
                        .toLowerCase()
                        .indexOf(lowercaseQuery)
                        .compareTo(
                            b.toLowerCase().indexOf(lowercaseQuery)));
                } else {
                  return students_list;
                }
              },
            );
                              }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                          stream: assgs.snapshots(),
                          builder: (context, snapshot) {
                            int pendingAmount = 0;
                            int pendingNo = 0;
                            if (!snapshot.hasData)
                              return Text("Loading.......");
                            for (DocumentSnapshot doc
                                in snapshot.data.documents) {
                              DateTime d = doc['due_date'].toDate();
                              DateTime t = DateTime.now();
                              if (d.day == t.day &&
                                  d.month == t.month &&
                                  d.year == t.year && doc['satus']=='ongoing'){
                                pendingNo++;
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AssDueToday()));
                                },
                                child: ActiveProjectsCard(
                                  title: "Assignments due today",
                                  subtitle: "",
                                  amount: pendingNo,
                                  cardColor: LightColors.kBlue,
                                ),
                              ),
                            );
                          }),
                      StreamBuilder(
                          stream: timed.snapshots(),
                          builder: (context, snapshot) {
                            int pendingAmount = 0;
                            if (!snapshot.hasData)
                              return Text("Loading.......");
                            for (DocumentSnapshot doc
                                in snapshot.data.documents) {
                              DateTime d = doc['due_date'].toDate();
                              DateTime t = DateTime.now();
                              if (d.day == t.day &&
                                  d.month == t.month &&
                                  d.year == t.year && doc['satus']=='ongoing')  {
                                pendingAmount++;
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TimedDueToday()));
                                },
                                child: ActiveProjectsCard(
                                  title: pendingAmount > 1
                                      ? "Timed ass sch. today"
                                      : "Timed ass sch. today",
                                  subtitle: "",
                                  amount: pendingAmount,
                                  cardColor: LightColors.kRed,
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            subheading('Assignments'),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        SizedBox(
                          height: 15.0,
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InProgress()));
                          },
                          child: TaskColumn(
                            icon: Icons.blur_circular,
                            iconBackgroundColor: LightColors.kDarkYellow,
                            title: 'In Progress',
                            subtitle: 'Ongoing assignments',
                          ),
                        ),
                        SizedBox(height: 15.0),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Done()));
                          },
                          child: TaskColumn(
                            icon: Icons.check_circle_outline,
                            iconBackgroundColor: LightColors.kBlue,
                            title: 'Done',
                            subtitle: 'Completed Assignments',
                          ),
                        ),
                        SizedBox(height: 15.0),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PastDue()));
                          },
                          child: TaskColumn(
                            icon: Icons.block,
                            iconBackgroundColor: LightColors.kRed,
                            title: 'Past Due',
                            subtitle: 'Assg. Past Due and Not completed',
                          ),
                        ),
                        SizedBox(height: 15.0),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PastDue()));
                          },
                          child: TaskColumn(
                            icon: Icons.alarm,
                            iconBackgroundColor: LightColors.kDarkBlue,
                            title: 'Timed Assignments',
                            subtitle: '',
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllAssignments()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                ),
                                width: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.text_snippet,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "All Assignments",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
