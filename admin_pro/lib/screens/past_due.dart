import 'package:flutter/material.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:admin_pro/widgets/data.dart';
import 'package:expandable/expandable.dart';
import 'package:admin_pro/widgets/task_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PastDue extends StatefulWidget {
  @override
  _PastDueState createState() => _PastDueState();
}

class _PastDueState extends State<PastDue> {
  
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

    DateTime d = doc['due_date'].toDate();
    String s = "${d.day}-${d.month}-${d.year}";

    DateTime d1 = doc['assigned_date'].toDate();
    String assignDate = "${d1.day}-${d1.month}-${d1.year}";

    return TaskContainer(
      title: doc['student'],
      subtitle: "Due " + s,
      boxColor: LightColors.kPalePink,
      price: doc['price'],
      tutor: doc['tutor'],
      assignedDate: assignDate,
      subject: doc['subject'],
      tutorFee: doc['tutor_fee'],
      id: doc.id,
      // a:assignments[index]
    );
  }


  @override
  Widget build(BuildContext context) {
    CollectionReference assgs =
        FirebaseFirestore.instance.collection('assignments');
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
                      "Past Due Assignments",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    StreamBuilder(
                        stream: assgs.where('due_date', isLessThan: DateTime.now()).snapshots(),
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