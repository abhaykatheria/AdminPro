import 'dart:io';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:admin_pro/theme/decorations.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_pro/widgets/constrained_container.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

final String username = 'abhay.katheria1998@gmail.com';
final String password = 'Kanpur@123';

final smtpServer = gmail(username, password);

class EditTaskView extends StatefulWidget {
 // EditTaskView({Key key}) : super(key: key);
  final String id;

  const EditTaskView({Key key, this.id}) : super(key: key);

  @override
  _EditTaskViewState createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final ValueChanged _onChanged = (val) => print(val);
  // Map<dynamic,dynamic> assMap;

  // Future<void> getAssignmentList() async {
  //   var result = await FirebaseFirestore.instance
  //       .collection('assignments').doc(widget.id).get();

  //     assMap = result.data();
  //   //print(assMap['ass_id']);
  // }

  // @override
  // void initState() {
  //   setState(() {
  //     getAssignmentList();
  //   });
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    CollectionReference assignments =
    FirebaseFirestore.instance.collection('assignments');

    CollectionReference tutors =
    FirebaseFirestore.instance.collection('tutors');

    CollectionReference dues = FirebaseFirestore.instance.collection('dues');

    CollectionReference payments =
    FirebaseFirestore.instance.collection('payment_collection');

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;






    List<String> _getTutorsList(BuildContext context, QuerySnapshot docs) {
      List<String> tutor_list = List();
      for (DocumentSnapshot doc in docs.docs) {
        tutor_list.add(doc['name']);
      }
      return tutor_list;
    }

    Future<void> uploadFile(
        String filePath, String file_name, String ass_id) async {
      File file = File(filePath);
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('files/' + ass_id + '/' + file_name)
            .putFile(file);
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
      }
    }

    String _tutorid = "";
    Future<void> UpdateAssignment(Map<String, dynamic> m) {

      return assignments.doc(widget.id).update({
        'student': m['student_name'],
        'tutor': m['tutor'],
        'subject': m['subject'],
        'price': m['price'],
        'amount_paid': m['amount_paid'],
        'tutor_fee': m["tutor_fee"],
        'due_date': Timestamp.fromDate(m['due_date']),
      }).then((value) {

        print("Assignment Updated");
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(
                title: Text('Assignment Updated'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Continue'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
        );

        print(m);
        Iterable<Attachment> toAt(Iterable<String> attachments) =>
            (attachments ?? []).map((a) => FileAttachment(File(a)));

        final message = Message()
          ..from = Address(username, 'Abhay Bhai')
          ..recipients.add('abhaykatheria01@gmail.com')
          ..subject = 'New Assignment:: 😀 :: ${DateTime.now()}'
          ..text = 'This is the plain text.\nThis is line 2 of the text part.'
          ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>"
          ..attachments.addAll(toAt(m['files'].values as Iterable<String>))
        ;

        try {
          final sendReport = send(message, smtpServer);
          print('Message sent: ' + sendReport.toString());
        } on MailerException catch (e) {
          print('Message not sent.');
          for (var p in e.problems) {
            print('Problem: ${p.code}: ${p.msg}');
          }
        }


        _fbKey.currentState.reset();

        /* tutors
            .where('name', isEqualTo: m['tutor'])
            .get()
            .then((value) => {
          value.docs.forEach((element) {
            _tutorid = element.id;
            tutors
                .doc(element.id)
                .update({"dues": element['dues'] + m['tutor_fee']});
          })
        })
            .catchError((error) {
          print("dues not updated");
        });*/

        /*  dues.add({
          'tutor': m['tutor'],
          'tutor_id': _tutorid,
          'due_date': Timestamp.fromDate(m['due_date']),
          'tutor_fee': m['tutor_fee'],
          'assg_id': value.id,
          'status': "pending"
        }).then((value) => null);*/

        /*payments.add({
          'student': m['student_name'],
          'due_date': Timestamp.fromDate(m['due_date']),
          'status': "pending",
          'pending': m['price'] - m['amount_paid'],
          'assg_id': value.id
        }).then((value) => null);
      }).catchError((error) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(error.toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Try Again Please'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ));*/

      });
    }



   // print(assMap['ass_id']);

    return Scaffold(
      appBar: AppBar(
        title: Text("Update assignment"),
      ),
      body: CenteredView(
        child: SafeArea(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
        .collection('assignments').doc(widget.id).get(),
            builder: (context, snapshot) {
              Map<dynamic,dynamic> assMap = snapshot.data.data();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    FormBuilder(
                        key: _fbKey,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            children: <Widget>[
                              FormBuilderTextField(
                                attribute: 'student_name',
                                maxLines: 1,
                                decoration: getTextDecoration(label:assMap['student']),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              StreamBuilder<Object>(
                                  stream: FirebaseFirestore.instance
                                      .collection("tutors")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return Text("Loading.......");

                                    return FormBuilderDropdown(
                                      attribute: 'tutor',
                                      decoration: getTextDecoration(label:'Tutor'),
                                      items: _getTutorsList(context, snapshot.data)
                                          .map((gender) => DropdownMenuItem(
                                          value: gender,
                                          child: Text("$gender")))
                                          .toList(),
                                    );
                                  }),
                              SizedBox(
                                height: 15.0,
                              ),
                              FormBuilderTextField(
                                attribute: "subject",
                                maxLines: 1,
                                decoration: getTextDecoration(label:assMap['subject']),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              FormBuilderTextField(
                                attribute: "price",
                                maxLines: 1,
                                decoration: getTextDecoration(label:assMap['price'].toString()),
                                valueTransformer: (value) => int.parse(value),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              FormBuilderTextField(
                                attribute: "amount_paid",
                                maxLines: 1,
                                decoration: getTextDecoration(label:assMap['amount_paid'].toString()),
                                valueTransformer: (value) => int.parse(value),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              FormBuilderTextField(
                                attribute: "tutor_fee",
                                maxLines: 1,
                                decoration: getTextDecoration(label:assMap['tutor_fee'].toString()),
                                valueTransformer: (value) => int.parse(value),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              FormBuilderDateTimePicker(
                                attribute: "due_date",
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Due date",
                                    suffixIcon: Icon(Icons.calendar_today)),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          _fbKey.currentState.reset();
                                        },
                                        child: Container(
                                          child: Center(
                                              child: Text(
                                                "Clear fields",
                                                style: TextStyle(color: Colors.white),
                                              )),
                                          height: 50.0,
                                          width: 150.0,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                              BorderRadius.circular(10.0)),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          if (_fbKey.currentState
                                              .saveAndValidate()) {
                                            print(_fbKey.currentState.value);
                                            print(_fbKey
                                                .currentState.value.runtimeType);
                                            UpdateAssignment(
                                                _fbKey.currentState.value);
                                          }
                                        },
                                        child: Container(
                                          child: Center(
                                              child: Text(
                                                "Update",
                                                style: TextStyle(color: Colors.white),
                                              )),
                                          height: 50.0,
                                          width: 150.0,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                              BorderRadius.circular(10.0)),
                                        ),
                                      ),
                                    ]),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
