import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_pro/widgets/active_project_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Financial extends StatefulWidget {
  Financial({Key key}) : super(key: key);

  @override
  _FinancialState createState() => _FinancialState();
}

class _FinancialState extends State<Financial> {
  Widget _buildListItem(
    BuildContext context,
    DocumentSnapshot doc,
  ) {
    DateTime d = doc['due_date'].toDate();
    String s = "${d.day}-${d.month}-${d.year}";
    return FlatButton(
      onPressed: () {},
      child: ListTile(
        title: Text(doc['student'] + "   " + "\$ " + doc['pending'].toString()),
        subtitle: Text(s) ,
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
      onPressed: () {},
      child: ListTile(
        title: Text(doc['tutor'] + "   " + "\$ " + doc['tutor_fee'].toString()),
        subtitle: Text(s) ,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference dues = FirebaseFirestore.instance.collection('dues');

    CollectionReference payments =
        FirebaseFirestore.instance.collection('payment_collection');

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Center(
              child: Text(
            "\$ Financials \$",
            style:
                GoogleFonts.dancingScript(textStyle: TextStyle(fontSize: 40.0)),
          )),
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
                      ),
                    );
                  }),
              StreamBuilder(
                  stream: dues.snapshots(),
                  builder: (context, snapshot) {
                    int pendingAmount = 0;
                    int pendingNo = 0;
                    if (!snapshot.hasData) return Text("Loading.......");
                    for (DocumentSnapshot doc in snapshot.data.documents) {
                      if (doc['status'] == 'pending') {
                        pendingAmount += doc['tutor_fee'];
                        pendingNo++;
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ActiveProjectsCard(
                        title: "payments pending",
                        subtitle: "to ${pendingNo} tutors",
                        amount: pendingAmount,
                        cardColor: Colors.teal,
                      ),
                    );
                  })
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.deepPurpleAccent),
              borderRadius: BorderRadius.circular(12)
              ),
              
              height: 320,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 9, 20, 0),
                          child: Text(
                            "Collections",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        StreamBuilder(
                          stream: payments.snapshots(),
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
                  VerticalDivider(
                    color: Colors.black,
                  ),
                  Expanded(
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
                          stream: dues.snapshots(),
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
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
