import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:admin_pro/theme/decorations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_pro/widgets/constrained_container.dart';

class AddTutor extends StatefulWidget {
  AddTutor({Key key}) : super(key: key);

  @override
  _AddTutorState createState() => _AddTutorState();
}

class _AddTutorState extends State<AddTutor> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final ValueChanged _onChanged = (val) => print(val);
  @override
  Widget build(BuildContext context) {
    CollectionReference tutors =
        FirebaseFirestore.instance.collection('tutors');

    Future<void> addTutor(Map<String, dynamic> m) {
      // Call the user's CollectionReference to add a new user
      return tutors
          .add({
            'name': m['name'], // John Doe
            'email': m['email'], // Stokes and Sons
            'country': m['country'],
            'dues': 0,
          })
          .then((value) => print("Tutor Added"))
          .catchError((error) => print("Failed to add tutor: $error"));
    }

    return CenteredView(
          child: Container(
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 15.0),
                Text(
                  "Add Tutor",
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
                          decoration: getTextDecoration("Tutor's name"),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        FormBuilderTextField(
                          attribute: "email",
                          decoration: getTextDecoration("Tutor's email"),
                          validators: [FormBuilderValidators.email()],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        FormBuilderCountryPicker(
                          // initialValue: 'Germany',
                          attribute: 'country',
                          // readOnly: true,
                          // style: TextStyle(color: Colors.black, fontSize: 18),
                          priorityListByIsoCode: ['US'],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Country',
                          ),
                          validators: [
                            FormBuilderValidators.required(
                                errorText: 'This field required.'),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    if (_fbKey.currentState.saveAndValidate()) {
                                      addTutor(_fbKey.currentState.value);
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text(
                                                    'Hurray'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                
                                                Text(
                                                    'Tutor has been Added'),
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
                                      "Add Tutor",
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
    );
  }
}
