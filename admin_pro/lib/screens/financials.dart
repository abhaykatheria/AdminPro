import 'package:admin_pro/screens/Transaction_result.dart';
import 'package:admin_pro/theme/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_pro/widgets/active_project_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_pro/screens/transactions.dart';

class Financial extends StatefulWidget {
  Financial({Key key}) : super(key: key);

  @override
  _FinancialState createState() => _FinancialState();
}

class _FinancialState extends State<Financial> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final ValueChanged _onChanged = (val) => print(val);

  @override
  Widget build(BuildContext context) {
    CollectionReference dues = FirebaseFirestore.instance.collection('dues');

    CollectionReference payments =
        FirebaseFirestore.instance.collection('payment_collection');

    Widget _buildListItem(
      BuildContext context,
      DocumentSnapshot doc,
    ) {
      DateTime d = doc['due_date'].toDate();
      String s = "${d.day}-${d.month}-${d.year}";
      return FlatButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Change Payment status"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('You are about to change the status to collected'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Mark Collected'),
                  onPressed: () {
                    payments
                        .doc(doc.id)
                        .update({'status': 'collected'})
                        .then((value) => print("updated"))
                        .catchError((err) => print(err));
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
        child: ListTile(
          title:
              Text("Student - " + doc['student']+"    Price - " + doc['pending'].toString() + "  \$"),
          subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Subject : " + doc['subject'] ),
            Text("Due date: $s"),
            Text(
                "Status: ${doc['status']}"
            )
          ]),
        ),
      );
    }

    Widget _buildListItem1(
      BuildContext context,
      DocumentSnapshot doc,
    ) {
      DateTime d = doc['due_date'].toDate();
      String s = "${d.day}-${d.month}-${d.year}";
      return FlatButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Change Payment status"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('You are about to change the status to transferred'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Mark transferred'),
                  onPressed: () {
                    dues
                        .doc(doc.id)
                        .update({'status': 'transferred'})
                        .then((value) => print("updated"))
                        .catchError((err) => print(err));
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
        child: ListTile(
          title:
              Text(doc['tutor'] + "   " + "\$ " + doc['tutor_fee'].toString()),
          subtitle: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Text(s),
            SizedBox(
              width: 15,
            ),
            Text(
              doc['status']
            )
          ]),
        ),
      );
    }

    List<String> _getTutorsList(BuildContext context, QuerySnapshot docs) {
      List<String> tutor_list = List();
      for (DocumentSnapshot doc in docs.docs) {
        tutor_list.add(doc['name']);
      }
      return tutor_list;
    }
    List<String> _getIdList(BuildContext context, QuerySnapshot docs) {
      List<String> tutor_list = List();
      for (DocumentSnapshot doc in docs.docs) {
        tutor_list.add(doc.id);
      }
      return tutor_list;
    }

    CollectionReference students =
    FirebaseFirestore.instance.collection('students');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            StreamBuilder<Object>(
                stream: students
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Text("Loading.......");
                  List<String> students_list = _getTutorsList(context, snapshot.data);
                  List<String> id_list = _getIdList(context, snapshot.data);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderTypeAhead(
                      decoration: getTextDecoration(label:"Student",prefix: ""),
                      attribute: 'student',
                      onChanged: _onChanged,
                      itemBuilder: (context, student) {
                        return ListTile(
                          title: Text(student),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TransactionResult(stud_name: student)));
                          },
                        );
                      },
                      controller: TextEditingController(text: ''),

                      suggestionsCallback: (query) {
                        if (query.isNotEmpty) {
                          var lowercaseQuery = query.toLowerCase();
                          return students_list.where((student) {
                            return student.toLowerCase().contains(lowercaseQuery);
                          }).toList(growable: false)
                            ..sort((a, b) => a
                                .toLowerCase()
                                .indexOf(lowercaseQuery)
                                .compareTo(
                                b.toLowerCase().indexOf(lowercaseQuery)));
                        } else {
                          return students_list;
                        }
                      },
                    ),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                    stream: payments.snapshots(),
                    builder: (context, snapshot) {
                      int pendingAmount = 0;
                      int pendingNo = 0;
                      if (!snapshot.hasData) return Text("Loading.......");
                      for (DocumentSnapshot doc in snapshot.data.documents) {
                        if (doc['status'] == 'pending') {
                          pendingAmount += doc['pending'];
                          pendingNo++;
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ActiveProjectsCard(
                          title: "needs to be collected",
                          subtitle: "from ${pendingNo} students",
                          amount: pendingAmount,
                          cardColor: Colors.amber,
                          extend: "\$",
                        ),
                      );
                    }),
                
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(12)),
                height: 320,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 9, 20, 0),
                            child: Text(
                              "Payments Collections",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          StreamBuilder(
                            stream: payments
                                .where('status', isEqualTo: 'pending')
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData)
                                return Text("Loading.......");
                              return Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _buildListItem(
                                      context,
                                      snapshot.data.documents[index],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    /*VerticalDivider(
                      color: Colors.black,
                    ),*/
                    /*Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 9, 0, 0),
                            child: Text(
                              "Transfers",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          StreamBuilder(
                            stream: dues
                                .where('status', isEqualTo: 'pending')
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData)
                                return Text("Loading.......");
                              return Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // var date = assignments[index].dueDate;
                                    // var formattedDate =
                                    //     "${date.day}-${date.month}-${date.year}";
                                    return _buildListItem1(
                                      context,
                                      snapshot.data.documents[index],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    )*/
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => transactions()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.text_snippet,
                            color: Colors.white,
                          ),
                          Text(
                            "All Transactions",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
