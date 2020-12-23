import 'package:flutter/material.dart';
import 'package:admin_pro/screens/add_tutor.dart';
import 'package:admin_pro/widgets/task_container.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_pro/screens/add_student.dart';

class Students extends StatefulWidget {
  @override
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  @override
  Widget build(BuildContext context) {
    Widget _buildListItem(BuildContext context, DocumentSnapshot doc, ){
    return StudentsContainer(
      name: doc['name'],
      email: doc['email'],
      time_zone: doc['time_zone'],
      boxColor: LightColors.kLightGreen,
      dues : doc['collections'],
      id: doc.id
    );
  }
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: () { 
              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddStudent()));
      },
        icon: Icon(Icons.add), label: Text('Add Student'),backgroundColor: Colors.red[500],heroTag: "btn1",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  
                  subheading("Students"),
                  SizedBox(
                    height: 15.0,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("students").snapshots(),
                    builder: (context, snapshot) {
                      if( !snapshot.hasData) return Text("Loading.......");
                      return 
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          // var date = assignments[index].dueDate;
                          // var formattedDate =
                          //     "${date.day}-${date.month}-${date.year}";
                          return _buildListItem(context, snapshot.data.documents[index],);
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(color: Colors.black,),
                        physics: const NeverScrollableScrollPhysics(),
                      );
                    }
                  ),
                  
                ],
              ),
            ),
          ),
        ),
    );
  }
}