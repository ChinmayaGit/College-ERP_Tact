import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SChat extends StatelessWidget {
  final String batch;

  SChat({required this.batch});

  @override
  Widget build(BuildContext context) {
    getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
      return snapshot.data!.docs
          .map(
            (doc) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                color: Colors.white,
                child: ListTile(

                  title: Center(
                      child: Text(
                          doc["GMAIL"].substring(0, doc["GMAIL"].length - 10))),
                  subtitle: Column(
                    children: <Widget>[
                      Text(doc['BATCH']),
                      Text(doc['BRANCH']),
                      // Text(doc['prodname']),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text("Chat", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 30,
              )),
          SizedBox(
            width: 20,
          ),
          Center(
              child: Text(
            "⋮",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('USERS')
            .where("BATCH", isEqualTo: batch)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text("There is no expense");
          return ListView(children: getExpenseItems(snapshot));
        },
      ),
    );
  }
}
