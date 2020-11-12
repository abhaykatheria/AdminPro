import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import "package:admin_pro/widgets/data.dart";
import 'package:admin_pro/theme/decorations.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

class CreateNewTask extends StatefulWidget {
  CreateNewTask({Key key}) : super(key: key);

  @override
  _CreateNewTaskState createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List tutorsList = ['abhay', 'raj'];
  final ValueChanged _onChanged = (val) => print(val);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add assignment"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FormBuilder(
                  key: _fbKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        FormBuilderTypeAhead<Tutor>(
                          decoration: getTextDecoration("Tutor"),
                          initialValue: contacts[0],
                          attribute: 'tutor',
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
                          decoration: InputDecoration(labelText: "Attachments", border: OutlineInputBorder()),
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                  child: Text('Submit'),
                                  onPressed: () {
                                    if (_fbKey.currentState.saveAndValidate()) {
                                      print(_fbKey.currentState.value);
                                    }
                                  }),
                              RaisedButton(
                                  child: Text("Clear"),
                                  onPressed: () {
                                    _fbKey.currentState.reset();
                                  })
                            ])
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
