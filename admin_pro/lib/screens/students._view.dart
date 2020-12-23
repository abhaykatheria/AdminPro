import 'package:flutter/material.dart';
import 'package:admin_pro/widgets/data.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_pro/theme/decorations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    Future<void> deleteAssignment() {
  return students
    .doc(widget.id)
    .delete()
    .then((value) => print("student Deleted"))
    .catchError((error) => print("Failed to delete user: $error"));
}

  return FutureBuilder<DocumentSnapshot>(
        future: students.doc(widget.id).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return Text("loading");
          }
          Map<String, dynamic> data = snapshot.data.data();
          
          return Scaffold(
            backgroundColor: LightColors.kLightGreen,
            body: SafeArea(
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
                                colors: [LightColors.kGreen, Colors.blue]
                                ),
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
                                    field: "Time Zone", value: data['time_zone']),
                                SizedBox(
                                  height: 12.0,
                                ),
                                taskviewfield(
                                    field: "Collection pending",
                                    value: data['collections'].toString() + " \$"),
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}