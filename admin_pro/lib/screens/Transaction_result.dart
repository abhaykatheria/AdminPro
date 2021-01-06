import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionResult extends StatefulWidget {
  final String stud_name;
  const TransactionResult({Key key, this.stud_name}) : super(key: key);

  @override
  _TransactionResultState createState() => _TransactionResultState();
}

class _TransactionResultState extends State<TransactionResult> {
  CollectionReference pc =
      FirebaseFirestore.instance.collection('payment_collection');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream:
                  pc.where('student', isEqualTo: widget.stud_name).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text("Loading.......");

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {

                    DocumentSnapshot doc = snapshot.data.documents[index];
                    DateTime d = doc['due_date'].toDate();
                    String s = "${d.day}-${d.month}-${d.year}";
                    print(doc['student']);
                    return ListTile(
                      onTap: (){
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
                                  pc
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
                      title:
                      Text(doc['student'] + "   " + "\$ " + doc['pending'].toString()),
                      subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Due date: $s"),
                            Text(
                                "Status: ${doc['status']}"
                            )
                          ]),
                    );
                  },
                  separatorBuilder:
                      (BuildContext context, int index) =>
                  const Divider(),
                  physics: const NeverScrollableScrollPhysics(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
