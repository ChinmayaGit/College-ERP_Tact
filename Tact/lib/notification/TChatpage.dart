import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TChat extends StatefulWidget {
  final String batch;
  final String sem;
  final String sub;
  final String teachUid;
  final String teachName;
  // bool check;
  TChat({required this.batch, required this.sem, required this.sub,required this.teachUid,required this.teachName
    // required this.check
  });

  @override
  _TChatState createState() => _TChatState();
}

class _TChatState extends State<TChat> {
  var chatController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map((doc) => MessageTile(
              message: doc["TEXT"],
              sendByMe: doc["SENDER"],
            ))
        .toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(FirebaseAuth.instance.currentUser!.email.toString()+" => "+widget.teachName),),
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.25,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("MESSAGES")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection(widget.sub)
                  .orderBy('TIME', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text("There is no expense");
                return ListView(
                    reverse: true, children: getExpenseItems(snapshot));
              },
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.30,
                  child: TextFormField(
                    controller: chatController,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Text is empty';
                      }
                      return null;
                    },
// onSaved: (value) => url = value,
                    decoration: InputDecoration(
                      hintText: 'Text',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5),
                child: GestureDetector(
                  onTap: () async{
                    _firestore
                        .collection("MESSAGES")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection(widget.sub)
                        .add({
                      "TEXT": chatController.text,
                      "SENDER_EMAIL": FirebaseAuth.instance.currentUser!.email,
                      "SENDER_UID": FirebaseAuth.instance.currentUser!.uid,
                      // "batch": widget.batch,
                      // "sem": widget.sem,
                      "SUB": widget.sub,
                      "TIME": DateTime.now(),
                      "SENDER": true,
                      // "check": widget.check,
                    });

                    final snapshots = await  _firestore
                        .collection("USERS")
                        .doc(widget.teachUid)
                        .collection("TEACHER").
                    doc("INFO").get();


                    _firestore
                        .collection("NOTIFICATION")
                        .add({
                      "SUBJECT":widget.sub,
                      "TEXT":chatController.text,
                      "TOKEN":snapshots.data()!["TOKEN"],
                    });
                    final deviceToken = await FirebaseMessaging.instance.getToken();

                    final snapshot = await  _firestore
                        .collection("USERS")
                        .doc(widget.teachUid)
                        .collection("MESSAGE").
                    doc(deviceToken).get();
                    if (snapshot.exists) {
                      print("Exists");

                    }else{
                      print("Not Exists");
                      _firestore
                          .collection("USERS")
                          .doc(widget.teachUid)
                          .collection("MESSAGE").
                      doc(FirebaseAuth.instance.currentUser!.email)
                          .set({
                        "UID": FirebaseAuth.instance.currentUser!.uid,
                        "EMAIL": FirebaseAuth.instance.currentUser!.email,
                        "TOKEN": deviceToken,
                      });

                      FirebaseFirestore.instance
                          .collection('USERS')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                      // .collection('TOKEN')
                      // .doc(deviceToken)
                          .update({
                        'TOKEN': deviceToken,
                      });
                    }


                    // _firestore
                    //     .collection("USERS")
                    //     .doc(widget.teachUid)
                    //     .collection("MESSAGES").
                    // doc(FirebaseAuth.instance.currentUser!.uid)
                    //     .get().then((value) {
                    //       if(value.get("").==0){
                    //      print("chinu Its Not null");
                    //       }else{
                    //         print("chinu Its null");
                    //
                    //       }
                    //
                    // });



                      // "UID": FirebaseAuth.instance.currentUser!.uid,
                      // "EMAIL": FirebaseAuth.instance.currentUser!.email,

                    chatController.clear();
                    FocusManager.instance.primaryFocus!.unfocus();
                    // setState(() {
                    //   widget.check=true;
                    // });
                    // // Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 25,
                    child: Center(
                      child: Icon(
                        Icons.send_rounded,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0xff80ed7e), const Color(0xff26cc23)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
