import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:admin_pro/theme/decorations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_pro/widgets/constrained_container.dart';


class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final ValueChanged _onChanged = (val) => print(val);
  @override
  Widget build(BuildContext context) {
    CollectionReference students =
        FirebaseFirestore.instance.collection('students');

    Future<void> addStudent(Map<String, dynamic> m) {
      // Call the user's CollectionReference to add a new user
      return students
          .add({
            'name': m['name'], // John Doe
            'email': m['email'],
            'time_zone' : m['time_zone'], // Stokes and Sons
            'collections': 0,
            'phone_number': m['phone_number'],
            'comments' : m['comments']
          })
          .then((value) => print("Student Added"))
          .catchError((error) => print("Failed to add student: $error"));
    }

    return CenteredView(
          child: Container(
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
                          child: Column(
                children: [
                  SizedBox(height: 15.0),
                  Text(
                    "Add Student",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  Divider(
                    color: Colors.black12,
                  ),
                  FormBuilder(
                    key: _fbKey,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormBuilderTextField(
                            attribute: 'name',
                            maxLines: 1,
                            decoration: getTextDecoration(label:"Student's name"),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderTextField(
                            attribute: "email",
                            decoration: getTextDecoration(label:"Student's email"),
                            validators: [FormBuilderValidators.email()],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderTextField(
                              attribute: "time_zone",
                              maxLines: 1,
                              decoration: getTextDecoration(label:"Time Zone",prefix: "UTC + "),
                            ),
                            SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderTextField(
                              attribute: "phone_number",
                              maxLines: 1,
                              decoration: getTextDecoration(label:"Time Zone",prefix: "UTC + "),
                              validators: [FormBuilderValidators.numeric()],
                            ),
                            SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderTextField(
                              attribute: "comments",
                              maxLines: 4,
                              decoration: getTextDecoration(label:"Comments",prefix: ""),
                            ),
                            SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      if (_fbKey.currentState.saveAndValidate()) {
                                        addStudent(_fbKey.currentState.value);
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(
                                                      'Hurray'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  
                                                  Text(
                                                      'Student has been Added'),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Continue'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _fbKey.currentState.reset();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      child: Center(
                                          child: Text(
                                        "Add Student",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      height: 50.0,
                                      width: 140.0,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                    ),
                                  ),
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
                                      width: 140.0,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                    ),
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}