import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:intl/intl.dart';
import 'package:admin_pro/widgets/task_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

// FirebaseApp secondaryApp = Firebase.app('adminpro');
// FirebaseFirestore firestore = FirebaseFirestore.instanceFor(app: secondaryApp);

// class InProgress extends StatelessWidget {
//   const InProgress({Key key}) : super(key: key);

// }

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}

DateTime firstDay(DateTime d){

  //DateTime n = DateTime.now();
  String month = d.month>9?"${d.month}":"0${d.month}";
  String day = d.day>9?"${d.day}":"0${d.day}";

  DateTime newd = DateTime.parse("${d.year}-" + month +"-"+ day + " 00:00:00Z");
  return newd.subtract(new Duration(days: d.weekday));
}

DateTime  lastDay(DateTime d){
  String month = d.month>9?"${d.month}":"0${d.month}";
  String day = d.day>9?"${d.day}":"0${d.day}";

  DateTime newd = DateTime.parse("${d.year}-" + month +"-"+ day + " 00:00:00Z");

  //DateTime newd = DateTime.parse("${d.year}-${d.month}-${d.day} 00:00:00Z");
  return newd.add(new Duration(days: 7-d.weekday));
}

class InProgress extends StatefulWidget {
  InProgress({Key key}) : super(key: key);

  @override
  _InProgressState createState() => _InProgressState();
}

class _InProgressState extends State<InProgress>  with SingleTickerProviderStateMixin {


  Widget _buildListItem(
    BuildContext context,
    DocumentSnapshot doc,
  ) {
    print(doc['student']);
    return TaskContainer(
      title: doc['student'],
      subtitle: "Due " + doc['due_date'].toDate().toString(),
      boxColor: LightColors.kLightYellow2,
      price: doc['price'],
      tutor: doc['tutor'],
      id: doc.id,
      // a:assignments[index]
    );
  }

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference assgs =
        FirebaseFirestore.instance.collection('assignments');


    Widget getData(String s){

      return Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                              child: Column(
                  children: <Widget>[
                    
                    SizedBox(height: 15.0),
                    StreamBuilder(
                        stream: assgs.where('satus', isEqualTo: "ongoing").orderBy(s, descending: true).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) return Text("Loading.......");
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {

                              return _buildListItem(
                                context,
                                snapshot.data.documents[index],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            physics: const NeverScrollableScrollPhysics(),
                          );
                        },
                      ),
                    
                    Divider(
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

    }
    return Scaffold(
      appBar: AppBar(
        title: Text("In progress"),
        backgroundColor: Colors.blueGrey,
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.white,
          tabs: [
            Tab(
              child: Text("sorted by due_date"),
            ),
            Tab(
              child: Text("sorted by assg_date"),
            ),
            
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          getData("due_date"),
          getData("assigned_date"),
        ],
        controller: _tabController,
      ),
    );
  }
}
