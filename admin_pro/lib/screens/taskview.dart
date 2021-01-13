import 'package:admin_pro/screens/edit_taskview.dart';
import 'package:admin_pro/screens/time_zones.dart';
import 'package:flutter/material.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_pro/theme/decorations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class TaskView extends StatefulWidget {
  TaskView({Key key, this.id}) : super(key: key);
  final String id;
  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
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
    CollectionReference assignments =
        FirebaseFirestore.instance.collection('assignments');
CollectionReference dues = FirebaseFirestore.instance.collection('dues');
    CollectionReference tutors =
    FirebaseFirestore.instance.collection('tutors');
CollectionReference students =
        FirebaseFirestore.instance.collection('students');

    Map<dynamic,dynamic> tutor_email;
    List<String> ld;

    Future<String> getEmail(String name) async{
      QuerySnapshot q = await tutors.where("name",isEqualTo: name).get();
      return q.docs[0]['email'];
    }

    Future<String> getStudentTimeZone(String name) async {
      QuerySnapshot q = await students.where("name", isEqualTo: name).get();
      return q.docs[0]['time_zone'];
    }
  Future<void> deleteAssignment() {
  return assignments
    .doc(widget.id)
    .delete()
    .then((value) => print("assignment Deleted"))
    .catchError((error) => print("Failed to delete user: $error"));
}
Future<String> getStudentId(String name) async {
      QuerySnapshot q = await students.where("name", isEqualTo: name).get();
      return q.docs[0].id;
    }
Future<void> updateStatus(String s,DocumentSnapshot m) {
  print(m);
      return assignments
          .doc(widget.id)
          .update({'satus': s})
          .then((value){
        if(s=='completed' && m['satus']!='completed'){

          print(widget.id);

          assignments.doc(widget.id).get().then((doc){
            tutors.where('name',isEqualTo: doc['tutor']).get().then((value) {
              tutors.doc(value.docs[0].id).update({
                'dues': value.docs[0]['dues'] + doc['tutor_fee'],
              }).then((b) async {
                  print(m.data());
                  print("sabbbbb bdhiyaaa hai bosssss");
                  String studentId = await getStudentId(doc['student']);
                  dues.add({

                    
          'tutor': m['tutor'],
          'tutorId': value.docs[0].id,
          'due_date': m['due_date'],
          'tutor_fee': m['tutor_fee'],
          'assg_id': widget.id,
          'status': "pending",
          'ass_type': "general",
          'studentId' : studentId,
          'subject' : m['subject']
        }).then((value) => print("dues adddddddddddeddddd" + studentId));

              });
              

            });
          });
        }

      }
      
      )
          .catchError((error) => print("Failed to update user: $error"));

    }

    Future<List<String>> listExample(String sid) async {
      List<String> ls= List<String>();

      //print('/files/$sid/');
      firebase_storage.ListResult result2 =
      await firebase_storage.FirebaseStorage.instance.ref('/files/$sid').listAll().catchError((e){});
      for (dynamic ref in result2.items){

        String downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref("${ref.fullPath}")
            .getDownloadURL().then((value){
          print(value);
          if(value.isNotEmpty){
            return value.toString();
          }
          return null;
        }).catchError((e){
          print(e);
        });
        ls.add(downloadURL);


      }

      return ls;
    }
    String formatDate2(Timestamp t){
      DateTime d = t.toDate();
      String formattedDate =
          "${d.day}/${d.month}/${d.year}";
      return formattedDate;
    }

    String getBodyString(List ld,Map<String, dynamic> m,String timeZone){
      String heading =
          "You have received a new assignment for \n student: ${m['student']} \n subject: ${m['subject']} \n The due date is ${formatDate(m['due_date'],time_zones[timeZone])} \n and the files can be find in the links below \n\n";

      String d="";
      try{
        ld.forEach((element) {
          d = d + element + "\n\n";
        });
      }
      catch(e){
      }

      d=heading+" "+d;

      print(d);
      return d;
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
  return assignments
    .doc(widget.id)
    .update({'due_date': t})
    .then((value) => print("status Updated"))
    .catchError((error) => print("Failed to update user: $error"));
    }
}

    return FutureBuilder<DocumentSnapshot>(
        future: assignments.doc(widget.id).get(),
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
                          "Assignment Details",
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
                                            return EditTaskView(
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
                                      value: data['tutor_fee'].toString() + " \$"),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Assigned Date",
                                      value: formatDate2(data['assigned_date']),),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  taskviewfield(
                                      field: "Due Date", value: formatDate2(data['due_date'])),
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
                        FlatButton(
                          onPressed: () async{
                            /*List<String> ld = await listExample(data['ass_id']);
                            //print(ld[0]);
                            String body = getBodyString(ld);
                            print(body);
                            */
                            listExample(data['ass_id']).then((value)async {
                              String TZ =await getStudentTimeZone(data['student_name']);
                              String body = getBodyString(value,data,TZ);

                              print(body);
                              String name = await getEmail(
                                  data['tutor']
                              );
                              final Email email = Email(
                                body: body,
                                subject: 'Feedback/Suggestion/Bug reporting',
                                recipients: [name],
                                //cc: ['cc@example.com'],
                                //bcc: ['bcc@example.com'],
                                //attachmentPaths: ['/path/to/attachment.zip'],
                                isHTML: false,
                              );

                              await FlutterEmailSender.send(email);


                            });




                          },
                          child: Container(
                            child: Center(
                                child: Text(
                                  "Send mail to tutor",
                                  style: TextStyle(color: Colors.white),
                                )),
                            height: 50.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: () {
                                  updateStatus('completed',snapshot.data).whenComplete(() =>  Navigator.of(context).pop());
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
                                updateStatus('incomplete',snapshot.data).whenComplete(() => Navigator.of(context).pop());
                                //deleteAssignment() ;
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
