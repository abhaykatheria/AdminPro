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
  int _value = 1;

  Widget _buildListItem(
    BuildContext context,
    DocumentSnapshot doc,
  ) {

    DateTime d = doc['due_date'].toDate();
    String s = "${d.day}-${d.month}-${d.year}";

    DateTime d1 = doc['assigned_date'].toDate();
    String assignDate = "${d1.day}-${d1.month}-${d1.year}";

    print(doc['price']);

    return doc['satus']=='ongoing' ? TaskContainer(
      title: doc['student'],
      subtitle: "Due: " + s + " Status : " + doc['satus'],
      boxColor: LightColors.kLightGreen,
      price: doc['price'],
      tutor: doc['tutor'],
      assignedDate: assignDate,
      subject: doc['subject'],
      tutorFee: doc['tutor_fee'],
      id: doc.id,
      // a:assignments[index]
    ) : SizedBox(
      height: 0,
    );
  }

  void _onDropDownChanged(int val) {
    setState(() {
      _value = val;
    });
  }

  Map m={
    1 : 'due_date',
    2 : 'assigned_date',
  };

  @override
  Widget build(BuildContext context) {
    CollectionReference assgs =
        FirebaseFirestore.instance.collection('assignments');

    return Scaffold(
      appBar: AppBar(
        title: Text("In progress"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Sort by:',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: DropdownButton(
                          value: _value,
                          items: [
                            DropdownMenuItem(
                              child: Text("Due Date"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Assigned Date"),
                              value: 2,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _onDropDownChanged(value);
                            });
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                StreamBuilder(
                  stream: assgs.orderBy(m[_value],descending: true)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
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
}
