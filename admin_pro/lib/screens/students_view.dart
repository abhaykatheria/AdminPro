import 'package:admin_pro/widgets/task_container.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:admin_pro/theme/decorations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentsView extends StatefulWidget {
  StudentsView({Key key, this.id}) : super(key: key);
  final String id;
  @override
  _StudentsViewState createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView> {

  @override
  Widget build(BuildContext context) {
    CollectionReference students =
        FirebaseFirestore.instance.collection('students');
    CollectionReference assgs =
        FirebaseFirestore.instance.collection('assignments');
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
    Future<void> deleteAssignment() {
      return students
          .doc(widget.id)
          .delete()
          .then((value) => print("student Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
    }

    return FutureBuilder<DocumentSnapshot>(
        future: students.doc(widget.id).get(),
        builder: (BuildContext context, snapshot) {
          print(widget.id);
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState != ConnectionState.done) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic> data = snapshot.data.data();
          print("--------------------******************");
          print(data);
          return Scaffold(
            backgroundColor: LightColors.kLightGreen,
            body: SafeArea(
              child: SingleChildScrollView(
                              child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        SizedBox(height: 15.0),
                        Text(
                          "Student Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [LightColors.kGreen, Colors.blue]),
                              backgroundBlendMode: BlendMode.darken,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            constraints: BoxConstraints(minWidth: 500),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Name", value: data['name']),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Email", value: data['email']),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Time Zone",
                                      value: data['time_zone']),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Collection pending",
                                      value:
                                          data['collections'].toString() + " \$"),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: () {
                                deleteAssignment();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                child: Center(
                                    child: Text(
                                  "Delete student",
                                  style: TextStyle(color: Colors.white),
                                )),
                                height: 50.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),

                          ],
                        ),
                         Divider(),
                      StreamBuilder<Object>(
                        stream: null,
                        builder: (context, snapshot) {
                          return ExpandablePanel(
                          header: Text(
                            "Assignments",
                            style: GoogleFonts.play(
                                textStyle: TextStyle(fontSize: 25.0)),
                          ),
                          expanded: StreamBuilder(
                            stream: assgs.where('student',isEqualTo: data['name']).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) return Text("Loading.......");
                              return Expanded(
                                child: ListView.separated(
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
                                ),
                              );
                            },
                          ),
                          tapHeaderToExpand: true,
                          hasIcon: true,
                    );
                        }
                      ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
