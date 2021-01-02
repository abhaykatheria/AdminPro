import 'package:flutter/material.dart';
import 'package:admin_pro/screens/add_tutor.dart';
import 'package:admin_pro/widgets/task_container.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Tutors extends StatefulWidget {
  @override
  _TutorsState createState() => _TutorsState();
}

class _TutorsState extends State<Tutors> {
  @override
  Widget build(BuildContext context) {


    Widget _buildListItem(BuildContext context, DocumentSnapshot doc, ){
    return TutorContainer(
      name: doc['name'],
      email: doc['email'],
      country: doc['country'],
      boxColor: LightColors.kLightGreen,
      dues : doc['dues'],
      id : doc.id
    );
  }
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: () { 
              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddTutor()));
      },
        icon: Icon(Icons.add), label: Text('Add Tutor'),backgroundColor: Colors.red[500],heroTag: "btn1",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      subheading("Tutors"),
                      
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  
                  SizedBox(
                    height: 15.0,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("tutors").snapshots(),
                    builder: (context, snapshot) {
                      if( !snapshot.hasData) return Text("Loading.......");
                      return 
                      Column(
                        children: [
                          FlatButton(
                          onPressed: () {
                            showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Mark all tutors Paid'),
            content: Text("This will mark all tutors paid"),
            actions: <Widget>[
              TextButton(
                child: Text('Continue'),
                onPressed: () {
                  for(DocumentSnapshot doc in snapshot.data.documents){
                    FirebaseFirestore.instance.collection("tutors").doc(doc.id).update({
                      'dues' : 0
                    })
    .then((value) => print("status Updated"))
    .catchError((error) => print("Failed to update user: $error"));
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Mark All Tutors Paid"),
                                    Icon(Icons.check_box),
                                  ],
                                ),
                              ),
                            ),
                            
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: LightColors.kBlue,
                            ),
                          ),
                      ),
                      SizedBox(height: 15.0,),
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
                          ),
                        ],
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