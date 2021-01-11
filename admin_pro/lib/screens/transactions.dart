import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class transactions extends StatefulWidget {
  @override
  _transactionsState createState() => _transactionsState();
}

class _transactionsState extends State<transactions> {
  @override
  Widget build(BuildContext context) {
    CollectionReference dues = FirebaseFirestore.instance.collection('dues');

    CollectionReference payments =
        FirebaseFirestore.instance.collection('payment_collection');

     CollectionReference assgs =
        FirebaseFirestore.instance.collection('assignments');



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
              Text(doc['student'] + "   " + "\$ " + doc['pending'].toString()),
          subtitle: Text(s),
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
          subtitle: Text(s),
        ),
      );
    }
 Widget _buildListItem2(
      BuildContext context,
      DocumentSnapshot doc,
    ) {
      DateTime d = doc['due_date'].toDate();
      String s = "${d.day}-${d.month}-${d.year}";

      
      
      return StreamBuilder<DocumentSnapshot>(
        stream: assgs.doc(doc['assg_id']).snapshots(),
        builder: (context, snapshot) {
          int ass_price = snapshot.data.data()['price'];
          return FlatButton(
            child: ListTile(
              title:
                  Text(doc['student'] + "   " + "\$ " + ass_price.toString()),
              subtitle: Text(s),
            ),
          );
        }
      );
    }

Widget _buildListItem3(
      BuildContext context,
      DocumentSnapshot doc,
    ) {
      DateTime d = doc['due_date'].toDate();
      String s = "${d.day}-${d.month}-${d.year}";
      return FlatButton(
        onPressed: () {
          
        },
        child: ListTile(
          title:
              Text(doc['tutor'] + "   " + "\$ " + doc['tutor_fee'].toString()),
          subtitle: Text(s),
        ),
      );
    }
    

    return Scaffold(
      appBar: AppBar(
        title: Text("All transactions"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExpandablePanel(
              header: Text(
                "Pending Collections",
                style: GoogleFonts.play(textStyle: TextStyle(fontSize: 25.0)),
              ),
              expanded: StreamBuilder(
                stream:
                    payments.where('status', isEqualTo: 'pending').snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return Text("Loading.......");
                  return Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        // var date = assignments[index].dueDate;
                        // var formattedDate =
                        //     "${date.day}-${date.month}-${date.year}";
                        return _buildListItem(
                          context,
                          snapshot.data.documents[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  );
                },
              ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
            
            ExpandablePanel(
              header: Text(
                "Pending Tutor Transfers",
                style: GoogleFonts.play(textStyle: TextStyle(fontSize: 25.0)),
              ),
              expanded: StreamBuilder(
                            stream: dues.where('status',isEqualTo: 'pending').snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData)
                                return Text("Loading.......");
                              return Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (BuildContext context, int index) {
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
                                  physics: const NeverScrollableScrollPhysics(),
                                ),
                              );
                            },
                          ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
            ExpandablePanel(
              header: Text(
                "Completed Collections",
                style: GoogleFonts.play(textStyle: TextStyle(fontSize: 25.0)),
              ),
              expanded: StreamBuilder(
                stream:
                    payments.where('status', isEqualTo: 'collected').snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return Text("Loading.......");
                  return Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        // var date = assignments[index].dueDate;
                        // var formattedDate =
                        //     "${date.day}-${date.month}-${date.year}";
                        return _buildListItem2(
                          context,
                          snapshot.data.documents[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  );
                },
              ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),

            ExpandablePanel(
              header: Text(
                "Completed Tutor Transfers",
                style: GoogleFonts.play(textStyle: TextStyle(fontSize: 25.0)),
              ),
              expanded: StreamBuilder(
                            stream: dues.where('status',isEqualTo: 'transferred').snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData)
                                return Text("Loading.......");
                              return Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    // var date = assignments[index].dueDate;
                                    // var formattedDate =
                                    //     "${date.day}-${date.month}-${date.year}";
                                    return _buildListItem3(
                                      context,
                                      snapshot.data.documents[index],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                  physics: const NeverScrollableScrollPhysics(),
                                ),
                              );
                            },
                          ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          ],
        ),
      )),
    );
  }
}
