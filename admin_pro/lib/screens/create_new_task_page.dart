import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';


class CreateNewTask extends StatefulWidget {
  CreateNewTask({Key key}) : super(key: key);

  @override
  _CreateNewTaskState createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add assignment"),),
      body: FormBuilder(
        key: _fbKey,
        child : Column(
          children: <Widget>[
          FormBuilderTextField(
            attribute: 'student_name',
            maxLines: 1,
            
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                
                RaisedButton(
                  child: Text('Submit'),
                  onPressed :(){
                    if(_fbKey.currentState.saveAndValidate()){
                      print(_fbKey.currentState.value);
                    }
                  }
                ),
                RaisedButton(
                  child: Text("Clear"),
                  onPressed: (){
                    _fbKey.currentState.reset();
                  }
                )
              ]
            )
          ],
        )
      ),
    );
  }
}