// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:intl/intl.dart';
import "package:admin_pro/widgets/data.dart";
import 'package:admin_pro/theme/decorations.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_pro/widgets/constrained_container.dart';

class CreateNewTask extends StatefulWidget {
  CreateNewTask({Key key}) : super(key: key);

  @override
  _CreateNewTaskState createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final ValueChanged _onChanged = (val) => print(val);
  @override
  Widget build(BuildContext context) {
    CollectionReference assignments =
        FirebaseFirestore.instance.collection('assignments');

    CollectionReference tutors =
        FirebaseFirestore.instance.collection('tutors');

    CollectionReference dues =
        FirebaseFirestore.instance.collection('dues');

    CollectionReference payments =
        FirebaseFirestore.instance.collection('payment_collection');

    List<String> _getTutorsList(BuildContext context, QuerySnapshot docs) {
      List<String> tutor_list = List();
      for (DocumentSnapshot doc in docs.docs) {
        tutor_list.add(doc['name']);
      }
      return tutor_list;
    }
    String _tutorid="";
    Future<void> addAssignment(Map<String, dynamic> m) {
      
      
      
      return assignments
          .add({
            'student': m['student_name'],
            'tutor': m['tutor'],
            'subject' : m['subject'],
            'price' : m['price'],
            'amount_paid':m['amount_paid'],
            'tutor_fee' : m["tutor_fee"],
            'due_date': Timestamp.fromDate(m['due_date']),
            'assigned_date': Timestamp.fromDate(DateTime.parse(m['assigned_date'])),
            'comments' : m['comments'],
            'satus': 'ongoing',
            'payment_pending':true,
          })
          .then((value) {
            print("Assignment Added");
            
          showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Assignment Added'),
                  
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
              _fbKey.currentState.reset();
            
            tutors.where('name' ,isEqualTo : m['tutor']  ).get().then((value) => {
              value.docs.forEach((element) {
                _tutorid = element.id;
                tutors.doc(element.id).update({"dues": element['dues'] + m['tutor_fee'] });
              })
            }).catchError((error){print("dues not updated");});

            dues.add(
              {
                'tutor' : m['tutor'],
                'tutor_id' : _tutorid,
                'due_date' : Timestamp.fromDate(m['due_date']),
                'tutor_fee': m['tutor_fee'],
                'assg_id' : value.id
              }
            ).then((value) => null);

            payments.add({
              'student' : m['student_name'],
              'due_date' : Timestamp.fromDate(m['due_date']),
              'status' : "pending",
              'pending' : m['price'] - m['amount_paid'],
              'assg_id' : value.id
            }).then((value) => null);
            
          })
          .catchError((error) => showDialog(
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
              ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add assignment"),
      ),
      body: CenteredView(
        child: SafeArea(
          child: SingleChildScrollView(
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
                            decoration: getTextDecoration("students name"),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          // FormBuilderTypeAhead<Tutor>(
                          //   decoration: getTextDecoration("Tutor"),
                          //   initialValue: contacts[0],
                          //   attribute: 'tutor',
                          //   onChanged: _onChanged,
                          //   itemBuilder: (context, Tutor tutor) {
                          //     return ListTile(
                          //       title: Text(tutor.name),
                          //       subtitle: Text(tutor.email),
                          //     );
                          //   },
                          //   selectionToTextTransformer: (Tutor c) => c.email,
                          //   suggestionsCallback: (query) {
                          //     if (query.isNotEmpty) {
                          //       var lowercaseQuery = query.toLowerCase();
                          //       return contacts.where((tutor) {
                          //         return tutor.name
                          //             .toLowerCase()
                          //             .contains(lowercaseQuery);
                          //       }).toList(growable: false)
                          //         ..sort((a, b) => a.name
                          //             .toLowerCase()
                          //             .indexOf(lowercaseQuery)
                          //             .compareTo(b.name
                          //                 .toLowerCase()
                          //                 .indexOf(lowercaseQuery)));
                          //     } else {
                          //       return contacts;
                          //     }
                          //   },
                          // ),
                          StreamBuilder<Object>(
                              stream: FirebaseFirestore.instance
                                  .collection("tutors")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Text("Loading.......");

                                return FormBuilderDropdown(
                                  attribute: 'tutor',
                                  decoration: getTextDecoration('Tutor'),
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
                          FormBuilderTypeAhead(
                            decoration: getTextDecoration("Time Zone"),
                            initialValue: contacts[0],
                            attribute: 'time_zone',
                            onChanged: _onChanged,
                            itemBuilder: (context, Tutor tutor) {
                              return ListTile(
                                title: Text(tutor.name),
                                subtitle: Text(tutor.email),
                              );
                            },
                            selectionToTextTransformer: (Tutor c) => c.email,
                            suggestionsCallback: (query) {
                              if (query.isNotEmpty) {
                                var lowercaseQuery = query.toLowerCase();
                                return contacts.where((tutor) {
                                  return tutor.name
                                      .toLowerCase()
                                      .contains(lowercaseQuery);
                                }).toList(growable: false)
                                  ..sort((a, b) => a.name
                                      .toLowerCase()
                                      .indexOf(lowercaseQuery)
                                      .compareTo(b.name
                                          .toLowerCase()
                                          .indexOf(lowercaseQuery)));
                              } else {
                                return contacts;
                              }
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderTextField(
                            attribute: "subject",
                            maxLines: 1,
                            decoration: getTextDecoration("Subject"),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderTextField(
                            attribute: "price",
                            maxLines: 1,
                            decoration: getTextDecoration("Price"),
                            valueTransformer: (value) => int.parse(value),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderTextField(
                            attribute: "amount_paid",
                            maxLines: 1,
                            decoration: getTextDecoration("Amount Paid"),
                            valueTransformer: (value) => int.parse(value),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderTextField(
                            attribute: "tutor_fee",
                            maxLines: 1,
                            decoration: getTextDecoration("Tutor Fee"),
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
                          FormBuilderTextField(
                            attribute: "assigned_date",
                            maxLines: 1,
                            decoration: getTextDecoration("Assigned Date"),
                            initialValue: DateTime.now().toString(),
                            readOnly: true,
                          ),
                          SizedBox(height: 15.0),
                          FormBuilderTextField(
                            attribute: "comments",
                            maxLines: 1,
                            decoration: getTextDecoration("Comments"),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderFilePicker(
                            attribute: "files",
                            decoration: InputDecoration(
                                labelText: "Attachments",
                                border: OutlineInputBorder()),
                            maxFiles: 5,
                            multiple: true,
                            previewImages: true,
                            onChanged: (val) => print(val),
                            fileType: FileType.any,
                            selector: Row(
                              children: <Widget>[
                                Icon(Icons.file_upload),
                                Text('Upload'),
                              ],
                            ),
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
                                        print(_fbKey.currentState.value.runtimeType);
                                        addAssignment(
                                            _fbKey.currentState.value);
                                      }
                                    },
                                    child: Container(
                                      child: Center(
                                          child: Text(
                                        "Add Assignment",
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
          ),
        ),
      ),
    );
  }
}
// RaisedButton(
//                                   child: Text('Submit'),
//                                   onPressed: () {
//                                     if (_fbKey.currentState.saveAndValidate()) {
//                                       print(_fbKey.currentState.value);
//                                     }
//                                   }),
//                               RaisedButton(
//                                   child: Text("Clear"),
//                                   onPressed: () {
//                                     _fbKey.currentState.reset();
//                                   })
