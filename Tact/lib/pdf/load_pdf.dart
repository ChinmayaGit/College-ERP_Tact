import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tact/pdf/FileDownloader.dart';
import 'package:tact/notification/TChatpage.dart';

import 'package:url_launcher/url_launcher.dart';

class PageLoader extends StatefulWidget {
  final String batch;
  final String sem;
  final String sub;

  PageLoader({
    required this.batch,
    required this.sem,
    required this.sub,
  });

  @override
  _PageLoaderState createState() => _PageLoaderState();
}

class _PageLoaderState extends State<PageLoader> {
  final _firestore = FirebaseFirestore.instance;
  bool check = false;
  late String teachUid;
  late String teachName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestore
        .collection('DOCUMENTS')
        .where("BATCH", isEqualTo: widget.batch)
        .where("SEMESTER", isEqualTo: widget.sem)
        .where("SUBJECT", isEqualTo: widget.sub)

        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        teachUid = result.get("UID");
        teachName = result.get("TEACHER_NAME");
      });
    });
    // _firestore
    //     .collection("Messages")
    //     .doc(widget.sub)
    //     .collection(widget.sub)
    //     .get()
    //     .then((querySnapshot) {
    //   querySnapshot.docs.forEach((result) {
    //     print(check);
    //     print("chinu");
    //     if (result.get("senderUid") == null) {
    //       setState(() {
    //         check = false;
    //       });
    //       print(check);
    //       print("chinu");
    //     } else {
    //       setState(() {
    //         check = true;
    //       });
    //       print(check);
    //       print("chinu");
    //
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrangeAccent,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => TChat(
                        batch: widget.batch,
                        sem: widget.sem,
                        sub: widget.sub,
                        teachUid: teachUid,
                        teachName: teachName

                        // check: check,
                        )));
          },
          child: Icon(Icons.message_outlined,color: Colors.white,),
        ),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Container(
            color: Color(0xFF00CCFF),
            child: Center(
                child: Text(
              widget.sub,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600),
            )),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color(0xFF00CCFF),
              const Color(0xFF3366FF),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('DOCUMENTS')
                // .doc(widget.batch)
                // .collection(widget.sem)
                .where("BATCH", isEqualTo: widget.batch)
                .where("SEMESTER", isEqualTo: widget.sem)
                .where("SUBJECT", isEqualTo: widget.sub)
                // .orderBy('createdAt', descending: true)

                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: Lottie.asset('assets/8370-loading.json'));
              return ListView(children: getExpenseItems(snapshot));
            },
          ),
        ),
      ),
    );
  }



  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    
    return snapshot.data!.docs
        .map(
          (doc) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                // decoration: ShapeDecoration(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: new BorderRadius.circular(18.0),
                //   ),
                //   color: Colors.red,
                // ),
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                    color: Colors.white),
                height: MediaQuery.of(context).size.height / 8,
                // width: MediaQuery.of(context).size.width/2,

                child: GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      barrierLabel: "Barrier",
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionDuration: Duration(milliseconds: 200),
                      context: context,
                      pageBuilder: (_, __, ___) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 180,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => FileDownloader(
                                                  doc["LINK"], doc["PDF"],widget.sub,widget.sem)));
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              height: 100,
                                              width: 100,
                                              child: Image.asset(
                                                  "assets/Doc.png")),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Material(
                                              type: MaterialType.transparency,
                                              //Makes it usable on any background color, thanks @IanSmith
                                              child: Ink(
                                                child: Text(
                                                  "Docs",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      launch(
                                          "https://pub.dev/packages/url_launcher");
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              height: 100,
                                              width: 100,
                                              child: Image.asset(
                                                  "assets/Vidicon.png")),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Material(
                                              type: MaterialType.transparency,
                                              //Makes it usable on any background color, thanks @IanSmith
                                              child: Ink(
                                                child: Text(
                                                  "Video Link",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(
                                bottom: 50, left: 12, right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        );
                      },
                      transitionBuilder: (_, anim, __, child) {
                        return SlideTransition(
                          position:
                              Tween(begin: Offset(0, 1), end: Offset(0, 0))
                                  .animate(anim),
                          child: child,
                        );
                      },
                    );
                  },
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            doc["SUBJECT"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                // this will show dots(...) after 2 lines
                                strutStyle: StrutStyle(fontSize: 12.0),
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  text:
                                      "${"Sem: " + doc['SEMESTER'].toString()}",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Doc: " + doc['PDF'],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                // this will show dots(...) after 2 lines
                                strutStyle: StrutStyle(fontSize: 12.0),
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  text:
                                      "${"Date: " + doc['DATE'].toDate().toString()}",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${"by: " + doc['TEACHER_NAME']}",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // subtitle: Column(
                    //   children: <Widget>[
                    //     Text(doc["name"],style: TextStyle(color: Colors.red),),
                    //     Text(doc['subject']),
                    //     Text(doc['teacher']),
                    //     Text(doc['branch']),
                    //   ],
                    // ),
                  ),
                )),
          ),
        )
        .toList();
  }
}
