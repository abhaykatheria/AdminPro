import 'package:admin_pro/screens/edit_taskview.dart';
import 'package:flutter/material.dart';
import 'package:admin_pro/widgets/data.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_pro/theme/decorations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_pro/screens/edit_timedview.dart';

class TimedView extends StatefulWidget {
  TimedView({Key key, this.id}) : super(key: key);
  final String id;
  @override
  _TimedViewState createState() => _TimedViewState();
}

class _TimedViewState extends State<TimedView> {
  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }



  @override
  Widget build(BuildContext context) {
    CollectionReference timed =
    FirebaseFirestore.instance.collection('timed');

    String formatDate(Timestamp t){
      DateTime d = t.toDate();
      String formattedDate =
          "${d.day}/${d.month}/${d.year}";
      return formattedDate;
    }


    Future<void> deleteAssignment() {
      return timed
          .doc(widget.id)
          .delete()
          .then((value) => print("Timed assignment Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
    }

    Future<void> updateStatus(String s) {
      return timed
          .doc(widget.id)
          .update({'satus': s})
          .then((value) => print("status Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }



    Future<void> updateDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          initialDatePickerMode: DatePickerMode.day,
          firstDate: DateTime(2015),
          lastDate: DateTime(2101));
      if (picked != null)
      {
        Timestamp t = Timestamp.fromDate(picked);
        return timed
            .doc(widget.id)
            .update({'start_date': t})
            .then((value) => print("status Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      }
    }




    return FutureBuilder<DocumentSnapshot>(
        future: timed.doc(widget.id).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState != ConnectionState.done) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          }
          Map<String, dynamic> data = snapshot.data.data();

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
                          "Timed assignment details",
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
                                  Row(
                                    children: [
                                      Spacer(),
                                      IconButton(
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (_){
                                            return EditTimedView(
                                                id: widget.id
                                            );
                                          }));
                                        },
                                        icon: Icon(Icons.edit),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Student", value: data['student']),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Subject", value: data['subject']),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Tutor", value: data['tutor']),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Price",
                                      value: data['price'].toString() + " \$"),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Amount Paid",
                                      value:
                                      data['amount_paid'].toString() + " \$"),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Tutor Fee",
                                      value: data['price'].toString() + " \$"),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                    field: "Assigned Date",
                                    value: formatDate(data['assigned_date']),),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Start Date", value: formatDate(data['start_date'])),
                                  SizedBox(height: 25.0),
                                  taskviewfield(
                                      field: "Status", value: data['satus']),
                                  SizedBox(height: 25.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        FlatButton(
                          onPressed: () {
                            deleteAssignment();
                            Navigator.of(context).pop();

                            //updateDate(context);
                          },
                          child: Container(
                            child: Center(
                                child: Text(
                                  "Delete Assignment",
                                  style: TextStyle(color: Colors.white),
                                )),
                            height: 50.0,
                            width: 320.0,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: () {
                                updateStatus('Completed');
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                child: Center(
                                    child: Text(
                                      "Mark Completed",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                height: 50.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                updateStatus('Incomplete');
                                //deleteAssignment() ;
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                child: Center(
                                    child: Text(
                                      "Mark Incomplete",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                height: 50.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                    color: Colors.deepOrangeAccent,
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
            ),
          );
        });
  }
}