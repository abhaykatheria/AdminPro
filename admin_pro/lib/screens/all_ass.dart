import 'package:flutter/material.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:admin_pro/widgets/data.dart';
import 'package:admin_pro/screens/timed_container.dart';
import 'package:expandable/expandable.dart';
import 'package:admin_pro/widgets/task_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
class AllAssignments extends StatefulWidget {
  AllAssignments({Key key}) : super(key: key);

  @override
  _AllAssignmentsState createState() => _AllAssignmentsState();
}

class _AllAssignmentsState extends State<AllAssignments> {
  int _value = 1;
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

  Widget _buildListItem(
    BuildContext context,
    DocumentSnapshot doc,
  ) {
    DateTime d = doc['due_date'].toDate();
    String s = "${d.day}-${d.month}-${d.year}";

    DateTime d1 = doc['assigned_date'].toDate();
    String assignDate = "${d1.day}-${d1.month}-${d1.year}";

    print(doc['price']);
    return TaskContainer(
      title: doc['student'],
      subtitle: "Due: " + s + " Status : " + doc['satus'],
      boxColor: LightColors.kLightGreen,
      price: doc['price'],
      tutor: doc['tutor'],
      assignedDate: assignDate,
      subject: doc['subject'],
      tutorFee: doc['tutor_fee'],
      id: doc.id,
      // a:assignments[index]
    );
  }

  Widget _buildListItem2(
      BuildContext context,
      DocumentSnapshot doc,
      ) {
    return TimedContainer(
      title: doc['student'],
      subtitle: "Due " + doc['due_date'].toDate().toString(),
      boxColor: LightColors.kPalePink,
      price: doc['price'],
      tutor: doc['tutor'],
      id: doc.id,
      // a:assignments[index]
    );
  }

  void _onDropDownChanged(int val) {
    setState(() {
      _value = val;
    });
  }

  Map m={
    1 : 'due_date',
    2 : 'student',
    3 :  'tutor'
  };


  @override
  Widget build(BuildContext context) {
    CollectionReference assgs =
        FirebaseFirestore.instance.collection('assignments');

    CollectionReference timed =
    FirebaseFirestore.instance.collection('timed');

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
                      "All Assignments",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Sort by:',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20.0),
                          child: DropdownButton(
                              value: _value,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Due Date"),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("Student Name"),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                    child: Text("Tutor Name"),
                                    value: 3
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _onDropDownChanged(value);
                                });
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    ExpandablePanel(
                      header: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Assignments",
                        style: GoogleFonts.play(textStyle: TextStyle(fontSize: 25.0)),
                      ),
                    ),
                      expanded: StreamBuilder(
                        stream: assgs
                            .orderBy(m[_value], descending: true)
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) return Text("Loading.......");
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildListItem(
                                context,
                                snapshot.data.documents[index],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) =>
                                const Divider(),
                            physics: const NeverScrollableScrollPhysics(),
                          );
                        },
                      ),
                    ),
                    Divider(
                      color: Colors.black12,
                    ),
                    ExpandablePanel(
                      header: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Timed",
                          style: GoogleFonts.play(textStyle: TextStyle(fontSize: 25.0)),
                        ),
                      ),
                      expanded: StreamBuilder(
                        stream: timed.orderBy(m[_value], descending: true).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) return Text("Loading.......");
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {

                              return _buildListItem2(
                                context,
                                snapshot.data.documents[index],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                            const Divider(),
                            physics: const NeverScrollableScrollPhysics(),
                          );
                        },
                      ),
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
