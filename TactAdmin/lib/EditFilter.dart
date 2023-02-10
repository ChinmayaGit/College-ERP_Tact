import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tactadmin/HomePage.dart';

import 'filters/filters.dart';

class CustomDrop extends StatefulWidget {
  @override
  _CustomDropState createState() => _CustomDropState();
}

class _CustomDropState extends State<CustomDrop> {
  var select,select1,select2,select3;

  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  String changeListener="BRANCH";
  String changeListener1="BATCH";
  String changeListener2="SEMESTER";
  String changeListener3="SUBJECT";
  var txtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: changeListener2!="SEMESTER"? FloatingActionButton.extended(onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  title: new Text(
                    "ADD SUBJECT",
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          controller: txtController,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Text is empty';
                            }
                            return null;
                          },
// onSaved: (value) => url = value,
                          decoration: InputDecoration(
                            hintText: 'SUBJECT',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                              child: new Text("Close"),
                              onPressed: () {
                                txtController.clear();
                                Navigator.pop(context);
                              }),
                        ),
                        Expanded(
                          child: FlatButton(
                            child: new Text("Upload"),
                            onPressed: () async {
                              FirebaseFirestore.instance
                                  .collection("SUBJECT").doc(select).collection(select2).doc(txtController.text.toUpperCase())
                                  .set({
                                "SUB": txtController.text.toUpperCase(),
                              });
                              // FirebaseFirestore.instance
                              //     .collection("NOTIFIERtemp")
                              //     .add({
                              //   "TOPIC": widget.batch,
                              //   "MSG": "New Subject Added ${txtController.text}",
                              //   "SUB": widget.sub,
                              // });
                              txtController.clear();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    )
                  ]);
            },);

        },
          label: Text("ADD NEW SUBJECT"),icon: const Icon(Icons.add_circle_rounded),
          backgroundColor: Colors.black,):Container(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.bars,
                color: Colors.white,
              ),
              onPressed: () {}),
          title: Container(
            alignment: Alignment.center,
            child: Text("EDIT Details",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.solidEdit,
                size: 20.0,
                color: Colors.white,
              ),
              onPressed: (){
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (_) => Branch()));
              },
            ),
          ],
        ),
        body: Form(
          key: _formKeyValue,
          autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: <Widget>[
              SizedBox(height: 40.0),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("BRANCH")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Text("Loading.....");
                    else {
                      var items = <String>[];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];
                        items.add(snap.id);
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height:40,
                            child: Material(
                              elevation:20,       color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(

                                  items: items
                                      .map((value) => DropdownMenuItem(

                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                            value,
                                            style:
                                            TextStyle(color: Colors.black)
                                        ),
                                      ),
                                    ),
                                    value: value,
                                  ))
                                      .toList(),
                                  onChanged: (currencyValue) {
                                    final snackBar = SnackBar(
                                      duration: Duration(microseconds: 5000),
                                      content: Text(
                                        'Selected Branch is $currencyValue',
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      select = currencyValue;
                                    });
                                    changeListener=currencyValue.toString();
                                  },
                                  value: select,
                                  isExpanded: false,
                                  hint: Center(
                                    child: new Text(
                                        " BRANCH",
                                        style: TextStyle(color: Colors.black)
                                    ),
                                  ),
                                ),
                              ),
                            ),),
                        ],
                      );
                    }
                  }),
              SizedBox(height: 20.0),
              changeListener!="BRANCH"?StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("BATCH").doc(changeListener).collection(changeListener)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Text("Loading.....");
                    else {
                      var item = <String>[];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];
                        item.add(snap.id);
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height:40,
                            child: Material(
                              elevation:20,       color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(30)),

                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(

                                  items: item
                                      .map((value) => DropdownMenuItem(

                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                            value,
                                            style:
                                            TextStyle(color: Colors.black)
                                        ),
                                      ),
                                    ),
                                    value: value,
                                  ))
                                      .toList(),
                                  onChanged: (currencyValue) {
                                    final snackBar = SnackBar(
                                      duration: Duration(microseconds: 5000),
                                      content: Text(
                                          'Selected Branch is $currencyValue',
                                          style: TextStyle(color: Colors.white)
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      select1 = currencyValue;
                                    });
                                    changeListener1=currencyValue.toString();
                                  },
                                  value: select1,
                                  isExpanded: false,
                                  hint: Center(
                                    child: new Text(
                                        " BATCH",
                                        style: TextStyle(color: Colors.black)
                                    ),
                                  ),
                                ),
                              ),
                            ),),
                        ],
                      );
                    }
                  }):Container(),
              SizedBox(height: 20.0),
              changeListener1!="BATCH"?StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("SEMESTER").doc(changeListener1).collection(changeListener1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Text("Loading.....");
                    else {
                      var items = <String>[];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];
                        items.add(snap['SEM']);
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height:40,
                            child: Material(
                              elevation:20,       color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(30)),

                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(

                                  items: items
                                      .map((value) => DropdownMenuItem(

                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                            value,
                                            style:
                                            TextStyle(color: Colors.black)
                                        ),
                                      ),
                                    ),
                                    value: value,
                                  ))
                                      .toList(),
                                  onChanged: (currencyValue) {
                                    final snackBar = SnackBar( duration: Duration(microseconds: 5000),
                                      content: Text(
                                          'Selected Branch is $currencyValue',
                                          style: TextStyle(color: Colors.white)
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      select2 = currencyValue;
                                    });
                                    changeListener2=currencyValue.toString();
                                  },
                                  value: select2,
                                  isExpanded: false,
                                  hint: Center(
                                    child: new Text(
                                        " SEMESTER",
                                        style: TextStyle(color: Colors.black)
                                    ),
                                  ),
                                ),
                              ),
                            ),),
                        ],
                      );
                    }
                  }):Container(),
              SizedBox(height: 20.0),
              changeListener2!="SEMESTER"?StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("SUBJECT").doc(changeListener).collection(changeListener2)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Text("Loading.....");
                    else {
                      var items = <String>[];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];
                        items.add(snap.id);
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height:40,
                            child: Material(
                              elevation:20,       color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(30)),

                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(

                                  items: items
                                      .map((value) => DropdownMenuItem(

                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                            value,
                                            style:
                                            TextStyle(color: Colors.black)
                                        ),
                                      ),
                                    ),
                                    value: value,
                                  ))
                                      .toList(),
                                  onChanged: (currencyValue) {
                                    final snackBar = SnackBar(
                                      duration: Duration(microseconds: 5000),
                                      content: Text(
                                          'Selected Branch is $currencyValue',
                                          style: TextStyle(color: Colors.white)
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      select3 = currencyValue;
                                    });
                                    changeListener3=currencyValue.toString();
                                  },
                                  value: select3,
                                  isExpanded: false,
                                  hint: Center(
                                    child: new Text(
                                        " SUBJECT",
                                        style: TextStyle(color: Colors.black)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }):Container(),
              SizedBox(height: 50.0),
              changeListener3!="SUBJECT"?Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      FirebaseFirestore.instance
                          .collection("USERS").doc(FirebaseAuth.instance.currentUser!.uid).collection("TEACHER").doc("INFO")
                          .update({
                        "BRANCH":select,
                        "BATCH": select1,
                        // "NAME": name.text,
                        "SEM":select2,
                        "SUB":select3,
                        "TIME":DateTime.now(),
                        // "TOKEN":FirebaseMessaging.instance.getToken(),
                      }).then((value) {
                        Phoenix.rebirth(context);
                      });
                    },
                    child: Container(

                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                        ),  color: Color(0xff11b719),
                      ),


                      child:    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("Submit", style: TextStyle(fontSize: 20.0,color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ):Container(),
            ],
          ),
        ));
  }
}
