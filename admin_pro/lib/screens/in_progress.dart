

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:admin_pro/widgets/data.dart';
import 'package:admin_pro/widgets/task_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



// FirebaseApp secondaryApp = Firebase.app('adminpro');
// FirebaseFirestore firestore = FirebaseFirestore.instanceFor(app: secondaryApp);

// class InProgress extends StatelessWidget {
//   const InProgress({Key key}) : super(key: key);
  
// }

class InProgress extends StatefulWidget {
  InProgress({Key key}) : super(key: key);

  @override
  _InProgressState createState() => _InProgressState();
}

class _InProgressState extends State<InProgress> {



  // bool _initialized = false;
  // bool _error = false;

  // // Define an async function to initialize FlutterFire
  // void initializeFlutterFire() async {
  //   try {
  //     // Wait for Firebase to initialize and set `_initialized` state to true
  //     await Firebase.initializeApp();
  //     setState(() {
  //       _initialized = true;
  //     });
  //   } catch(e) {
  //     // Set `_error` state to true if Firebase initialization fails
  //     setState(() {
  //       _error = true;
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   initializeFlutterFire();
  //   super.initState();
  // }


  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot doc ){
    return TaskContainer(
                              title: doc['student'],
                              subtitle: "Due " + doc['due_date'].toDate().toString(),
                              boxColor: LightColors.kLightYellow2,
                              price: doc['price'],
                              tutor: "katheria" ,
                              // a:assignments[index]
                            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15.0),
                  Text(
                    "Upcoming Tasks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  Divider(
                    color: Colors.black12,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  subheading("This week"),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 125.0*assignments.length,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("assignments").snapshots(),
                      builder: (context, snapshot) {
                        if( !snapshot.hasData) return Text("Loading.......");
                        return 
                        ListView.separated(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            // var date = assignments[index].dueDate;
                            // var formattedDate =
                            //     "${date.day}-${date.month}-${date.year}";
                            return _buildListItem(context, snapshot.data.documents[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          physics: const NeverScrollableScrollPhysics(),
                        );
                      }
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  subheading("After This week"),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 125.0*assignments.length,
                    child: ListView.separated(
                      itemCount: assignments.length,
                      itemBuilder: (BuildContext context, int index) {
                        var date = assignments[index].dueDate;
                        var formattedDate =
                            "${date.day}-${date.month}-${date.year}";
                        return TaskContainer(
                          title: assignments[index].student,
                          subtitle: "Due " + formattedDate,
                          boxColor: LightColors.kLightGreen,
                          price: assignments[index].price,
                          tutor: "katheria",
                          a: assignments[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      physics: const NeverScrollableScrollPhysics(),
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