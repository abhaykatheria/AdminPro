import 'dart:io';
import 'package:admin_pro/screens/time_zones.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:admin_pro/theme/decorations.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_pro/widgets/constrained_container.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_email_sender/flutter_email_sender.dart';

class AddTimed extends StatefulWidget {
  AddTimed({Key key}) : super(key: key);

  @override
  _AddTimedState createState() => _AddTimedState();
}

class _AddTimedState extends State<AddTimed> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final ValueChanged _onChanged = (val) => print(val);
  Duration _duration = Duration(hours: 0, minutes: 0);
  @override
  Widget build(BuildContext context) {
    CollectionReference timed = FirebaseFirestore.instance.collection('timed');

    CollectionReference tutors =
        FirebaseFirestore.instance.collection('tutors');

    CollectionReference dues = FirebaseFirestore.instance.collection('dues');

    CollectionReference payments =
        FirebaseFirestore.instance.collection('payment_collection');

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    CollectionReference students =
        FirebaseFirestore.instance.collection('students');

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
    Future<String> getStudentTimeZone(String name) async {
      QuerySnapshot q = await students.where("name", isEqualTo: name).get();
      return q.docs[0]['time_zone'];
    }

    Future<String> getEmail(String name) async {
      QuerySnapshot q = await tutors.where("name", isEqualTo: name).get();
      return q.docs[0]['email'];
    }

    Future<List<String>> listExample(String sid) async {
      List<String> ls = List<String>();

      //print('/files/$sid/');
      firebase_storage.ListResult result2 = await firebase_storage
          .FirebaseStorage.instance
          .ref('/files/$sid')
          .listAll()
          .catchError((e) {});
      for (dynamic ref in result2.items) {
        String downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref("${ref.fullPath}")
            .getDownloadURL()
            .then((value) {
          print(value);
          if (value.isNotEmpty) {
            return value.toString();
          }
          return null;
        }).catchError((e) {
          print(e);
        });
        ls.add(downloadURL);
      }

      return ls;
    }

    String getBodyString(List ld, Map<String, dynamic> m,String timeZone) {
      String heading =
          "You have received a new assignment for \n student: ${m['student_name']} \n subject: ${m['subject']} \n The start date is ${formatDate(Timestamp.fromDate(m['start_date']),time_zones[timeZone])} \n and the files can be find in the links below \n\n";
      String d = "";
      try {
        ld.forEach((element) {
          d = d + element + "\n\n";
        });
      } catch (e) {}

      d = heading + " " + d;

      print(d);
      return d;
    }

    Future<bool> uploadAllFiles(Map<String, dynamic> m, String ass_id) async {
      try {
        if (m.containsKey('files')) {
          String file_links = "";
          for (String file_name in m['files'].keys) {
            await uploadFile(m['files'][file_name], file_name, ass_id);
          }
        }
        return true;
      } catch (e) {
        print(e);
      }
    }

    String _tutorid = "";
    Future<void> addTimed(Map<String, dynamic> m, Duration duration) async {
      String timed_id = randomString(10);

      try {
        if (m.containsKey('files')) {
          String file_links = "";
          for (String file_name in m['files'].keys) {
            uploadFile(m['files'][file_name], file_name, timed_id);
          }
        }
      } catch (e) {
        print(e);
      }
      String email_name = await getEmail(m['tutor']);
      return timed.add({
        'ass_id': timed_id,
        'student': m['student_name'],
        'tutor': m['tutor'],
        'tutor_email': email_name,
        'subject': m['subject'],
        'price': m['price'],
        'amount_paid': m['amount_paid'],
        'tutor_fee': m["tutor_fee"],
        'due_date': Timestamp.fromDate(m['start_date']),
        'start_date': Timestamp.fromDate(m['start_date']),
        'duration': duration.toString(),
        'assigned_date': Timestamp.fromDate(m['assigned_date']),
        'comments': m['comments'],
        'satus': 'ongoing',
        'payment_pending': true,
      }).then((value) {
        print("Assignment Added");
        print(m);

        // _fbKey.currentState.reset();
        String ass_id = value.id;
        tutors
            .where('name', isEqualTo: m['tutor'])
            .get()
            .then((value) => {
                  value.docs.forEach((element) {
                    _tutorid = element.id;
                  })
                })
            .catchError((error) {
          print("dues not updated");
        });

        // dues.add({
        //   'tutor': m['tutor'],
        //   'tutorId': _tutorid,
        //   'due_date': Timestamp.fromDate(m['start_date']),
        //   'tutor_fee': m['tutor_fee'],
        //   'assg_id': value.id,
        //   'status': "pending",
        //   'ass_type': "timed"
        // }).then((value) => null);

        payments.add({
          'student': m['student_name'],
          'due_date': Timestamp.fromDate(m['start_date']),
          'status': "pending",
          'pending': m['price'] - m['amount_paid'],
          'assg_id': timed_id,
          'subject' :m['subject']
        }).then((value) => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: FutureBuilder<bool>(
                  future: uploadAllFiles(m, ass_id),
                  builder: (context, val) {
                    print(val);
                    if (val.data == true) {
                      return Text('File uploaded');
                    } else {
                      return Container(
                        height: 50,
                        width: 50,
                        child: Column(
                          children: [
                            //Text('File are being uploaded'),
                            SizedBox(
                                height: 20, child: CircularProgressIndicator())
                          ],
                        ),
                      );
                    }
                  },
                ),
                title: Text('Assignment Added'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Continue'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                      child: Text('Send mail to tutor'),
                      onPressed: () {
                        listExample(ass_id).then((value) async {
                          String TZ =await getStudentTimeZone(m['student_name']);

                          String body = getBodyString(value, m,TZ);

                          print(body);
                          String name = await getEmail(m['tutor']);
                          //print('gg ${m['tutor']}');
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
                      }),
                ],
              ),
            ));
      }).catchError((e) => print(e));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Timed"),
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
                          StreamBuilder<Object>(
                              stream: students.snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Text("Loading.......");
                                List<String> students_list =
                                    _getTutorsList(context, snapshot.data);
                                return FormBuilderTypeAhead(
                                  decoration: getTextDecoration(
                                      label: "Student", prefix: ""),
                                  attribute: 'student_name',
                                  onChanged: _onChanged,
                                  itemBuilder: (context, student) {
                                    return ListTile(
                                      title: Text(student),
                                    );
                                  },
                                  controller: TextEditingController(text: ''),
                                  suggestionsCallback: (query) {
                                    if (query.isNotEmpty) {
                                      var lowercaseQuery = query.toLowerCase();
                                      return students_list.where((student) {
                                        return student
                                            .toLowerCase()
                                            .contains(lowercaseQuery);
                                      }).toList(growable: false)
                                        ..sort((a, b) => a
                                            .toLowerCase()
                                            .indexOf(lowercaseQuery)
                                            .compareTo(b
                                                .toLowerCase()
                                                .indexOf(lowercaseQuery)));
                                    } else {
                                      return students_list;
                                    }
                                  },
                                );
                              }),
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
                                  decoration: getTextDecoration(label: 'Tutor'),
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
                            decoration: getTextDecoration(label: "Subject"),
                            validators: [FormBuilderValidators.maxLength(12)],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderTextField(
                            attribute: "price",
                            maxLines: 1,
                            decoration: getTextDecoration(label: "Price"),
                            valueTransformer: (value) => int.parse(value),
                            validators: [FormBuilderValidators.numeric()],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderTextField(
                            attribute: "amount_paid",
                            maxLines: 1,
                            decoration: getTextDecoration(label: "Amount Paid"),
                            valueTransformer: (value) => int.parse(value),
                            validators: [FormBuilderValidators.numeric()],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderTextField(
                            attribute: "tutor_fee",
                            maxLines: 1,
                            decoration: getTextDecoration(label: "Tutor Fee"),
                            valueTransformer: (value) => int.parse(value),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderDateTimePicker(
                            attribute: "start_date",
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Start date",
                                suffixIcon: Icon(Icons.calendar_today)),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text("Duration"),
                          DurationPicker(
                            duration: _duration,
                            onChange: (val) {
                              this.setState(() => _duration = val);
                            },
                            snapToMins: 5.0,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FormBuilderDateTimePicker(
                            attribute: "assigned_date",
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Assigned Date",
                                suffixIcon: Icon(Icons.calendar_today)),
                          ),
                          SizedBox(height: 15.0),
                          FormBuilderTextField(
                            attribute: "comments",
                            maxLines: 1,
                            decoration: getTextDecoration(label: "Comments"),
                            validators: [FormBuilderValidators.maxLength(30)],
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
                                        print(_fbKey
                                            .currentState.value.runtimeType);
                                        addTimed(_fbKey.currentState.value,
                                            _duration);
                                      }
                                    },
                                    child: Container(
                                      child: Center(
                                          child: Text(
                                        "Add Timed",
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
