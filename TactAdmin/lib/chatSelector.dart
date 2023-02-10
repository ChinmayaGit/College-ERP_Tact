import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tactadmin/Chat.dart';


class ChatSelect extends StatelessWidget {
    final String batch;
  final String sem;
  final String sub;
    ChatSelect({required this.batch, required this.sem, required this.sub,});

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot,context) {
    return snapshot.data!.docs
        .map(
          (doc) => GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Chat(
                    batch: batch,
                    sem: sem,
                    sub: sub,
                    token: doc["TOKEN"],
                    Uid: doc["UID"],
                  )));
        },
        child: ListTile(
          title: Material(
              elevation: 20,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Center(child: Text(" ${doc["EMAIL"].substring(0, doc["EMAIL"].length - 10)}")),
              )),
          // subtitle: Column(
          //   children: <Widget>[
          //     // Text(doc['Address']),
          //     // Text(doc['Phone no.']),
          //     // Text(doc['prodname']),
          //   ],
          // ),
        ),
      ),
    )
        .toList();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,elevation: 0,title: Text("Chat",style: TextStyle(color: Colors.black)),centerTitle: true,),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('USERS')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("MESSAGE")
        // .where("sub", isEqualTo: widget.sub)
        // .where("sem", isEqualTo: widget.sem)
        // .where("batch", isEqualTo: widget.batch)
        // .where("check", isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text("There is no expense");
          return ListView(children: getExpenseItems(snapshot,context));
        },
      ),
    );
  }
}

// class ChatSelect extends StatefulWidget {
//   final String batch;
//   final String sem;
//   final String sub;
//   ChatSelect({required this.batch, required this.sem, required this.sub,
//
//   });
//
//   @override
//   _ChatSelectState createState() => _ChatSelectState();
// }
//
// class _ChatSelectState extends State<ChatSelect> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     print("chinu");
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('USERS')
//             .doc(FirebaseAuth.instance.currentUser!.uid)
//             .collection("MESSAGE")
//             // .where("sub", isEqualTo: widget.sub)
//             // .where("sem", isEqualTo: widget.sem)
//             // .where("batch", isEqualTo: widget.batch)
//             // .where("check", isEqualTo: false)
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) return Text("There is no expense");
//           return ListView(children: getExpenseItems(snapshot));
//         },
//       ),
//     );
//   }
// }
