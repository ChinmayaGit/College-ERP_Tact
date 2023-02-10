import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {

  String Batch;
  Notifications({required this.Batch});

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),color: Colors.black26,
              ),

              child: ListTile(
        title: Text(doc["SUB"]),
        subtitle: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(doc['MSG']),
                ),

                doc['IMAGE']==""?Container():Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(doc['IMAGE']),
                ),


              ],
        ),
      ),
            ),
          ),
    )
        .toList();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('NOTIFIER').where("TOPIC",isEqualTo:Batch).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text("There is no expense");
          return ListView(children: getExpenseItems(snapshot));
        },
      ),
    );
  }
}
