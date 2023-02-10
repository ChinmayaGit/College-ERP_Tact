import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tactadmin/HomePage.dart';
import 'package:tactadmin/Login/SignUp.dart';
import 'package:tactadmin/main.dart';

String key = "";
final TextEditingController name = TextEditingController();
var txtController = TextEditingController();
TextEditingController code = new TextEditingController();

class Branch extends StatefulWidget {
  @override
  _BranchState createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  bool setTime = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getUser() async {
    return _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 6), () {
      setState(() {
        setTime = false;
      });
    });

    getUser().then((user) {
      if (user != null) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => MyHomePage()));
      }
    });

    FirebaseFirestore.instance
        .collection("ADMINKEY")
        .doc("dNvEB5H9AJwbaMNjnZxx")
        .get()
        .then((value) {
      setState(() {
        key = value.data()!["KEY"];
      });
    });
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => ListTile(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: Center(
                        child: new Text(
                          "DELETE BRANCH",
                        ),
                      ),
                      actions: <Widget>[
                        Center(
                            child: Text(
                                "Enter Key To Delete Branch ${doc["BRANCH"]}")),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: TextFormField(
                            maxLength: 4,
                            autofocus: false,
                            controller: code,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
// onSaved: (value) => url = value,
                            decoration: InputDecoration(
                              hintText: 'Key',
                              labelText: 'Your Admin Key',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(
                                Icons.keyboard_control_sharp,
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
                                child: new Text("DELETE"),
                                onPressed: () async {
                                  if (code.text == key) {
                                    FirebaseFirestore.instance
                                        .collection("BRANCH")
                                        .doc(doc["BRANCH"])
                                        .delete();
                                    txtController.clear();
                                    Navigator.pop(context);
                                  } else {
                                    code.clear();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20.0),
                                          ),
                                          title: Center(
                                            child: new Text(
                                              "Wrong Key",
                                            ),
                                          ),
                                          actions: [
                                            FlatButton(
                                                child: Center(
                                                    child: new Text("Close")),
                                                onPressed: () {
                                                  txtController.clear();
                                                  Navigator.pop(context);
                                                }),
                                          ],
                                        );
                                      },
                                    );
                                  }

                                },
                              ),
                            ),
                          ],
                        )
                      ]);
                },
              );
            },
            onTap: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Batch(branch: doc["BRANCH"])));
            },
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                    backgroundColor: Colors.red,
                    avatar: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(doc["BRANCH"][0]),
                    ),
                    label: Text(
              doc["BRANCH"],
              style: TextStyle(color: Colors.white, fontSize: 20),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Center(
                  child: new Text(
                    "Enter the Admin KEY",
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      maxLength: 4,
                      autofocus: false,
                      controller: code,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
// onSaved: (value) => url = value,
                      decoration: InputDecoration(
                        hintText: 'Key',
                        labelText: 'Your Admin Key',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.keyboard_control_sharp,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            child: new Text("Enter"),
                            onPressed: () {
                              if (code.text == key) {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        title: Center(
                                          child: new Text(
                                            "ADD BRANCH",
                                          ),
                                        ),
                                        actions: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 80,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.25,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: 5,
                                                minLines: 1,
                                                controller: txtController,
                                                validator: (text) {
                                                  if (text == null ||
                                                      text.isEmpty) {
                                                    return 'Text is empty';
                                                  }
                                                  return null;
                                                },
// onSaved: (value) => url = value,
                                                decoration: InputDecoration(
                                                  hintText: 'Branch',
                                                  labelText: 'BRANCH',
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
                                                        .collection("BRANCH")
                                                        .doc(txtController.text
                                                            .toUpperCase())
                                                        .set({
                                                      "BRANCH": txtController
                                                          .text
                                                          .toUpperCase(),
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
                                  },
                                );
                              } else {
                                code.clear();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      title: Center(
                                        child: new Text(
                                          "Wrong Key",
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                            child: Center(
                                                child: new Text("Close")),
                                            onPressed: () {
                                              txtController.clear();
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        label: Text("ADD NEW BRANCH"),
        icon: const Icon(Icons.add_circle_rounded),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: setTime == true
          ? Center(
              child: Lottie.asset('assets/9757-welcome.json'),
            )
          : SingleChildScrollView(
            child: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(

                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          title: Center(
                            child: new Text(
                              "Enter the Admin KEY",
                            ),
                          ),
                          actions: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: TextFormField(
                                maxLength: 4,
                                autofocus: false,
                                controller: code,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Text is empty';
                                  }
                                  return null;
                                },
// onSaved: (value) => url = value,
                                decoration: InputDecoration(
                                  hintText: 'Key',
                                  labelText: 'Your Admin Key',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(
                                    Icons.keyboard_control_sharp,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: FlatButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: FlatButton(
                                      child: new Text("Enter"),
                                      onPressed: () {
                                        if (code.text == key) {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(builder: (context) => SignUp()),
                                          );
                                        } else {
                                          code.clear();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // return object of type Dialog
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(20.0),
                                                ),
                                                title: Center(
                                                  child: new Text(
                                                    "Wrong Key",
                                                  ),
                                                ),
                                                actions: [
                                                  FlatButton(
                                                      child: Center(
                                                          child: new Text("Close")),
                                                      onPressed: () {
                                                        txtController.clear();
                                                        Navigator.pop(context);
                                                      }),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );

                  },
                  child: Container(
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                        ),color: Colors.lightBlueAccent
                    ),

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30.0,10,30,10),
                      child: Text("Create Account: \nAdmin/Students",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),)),
            ),
            StreamBuilder(

              stream: FirebaseFirestore.instance.collection('BRANCH').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text("There is no expense");
                return Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                  child: Container(
                    height: 500,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        color: Colors.black12,
                      ),
                      child: ListView(
                          shrinkWrap: true,
                          children: getExpenseItems(snapshot))),
                );
              },
            ),

        ],

            ),
          ),
    );
  }
}

class Batch extends StatefulWidget {
  final String branch;

  Batch({required this.branch});

  @override
  _BatchState createState() => _BatchState();
}

class _BatchState extends State<Batch> {
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => ListTile(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: Center(
                        child: new Text(
                          "DELETE BATCH",
                        ),
                      ),
                      actions: <Widget>[
                        Center(
                            child: Text(
                                "Enter Key To Delete Batch ${doc["BATCH"]}")),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: TextFormField(
                            maxLength: 4,
                            autofocus: false,
                            controller: code,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
// onSaved: (value) => url = value,
                            decoration: InputDecoration(
                              hintText: 'Key',
                              labelText: 'Your Admin Key',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(
                                Icons.keyboard_control_sharp,
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
                                child: new Text("DELETE"),
                                onPressed: () async {
                                  if (code.text == key) {
                                    FirebaseFirestore.instance
                                        .collection("BATCH")
                                        .doc(widget.branch)
                                        .collection(widget.branch)
                                        .doc(doc["BATCH"])
                                        .delete();
                                    txtController.clear();
                                    Navigator.pop(context);
                                  } else {
                                    code.clear();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20.0),
                                          ),
                                          title: Center(
                                            child: new Text(
                                              "Wrong Key",
                                            ),
                                          ),
                                          actions: [
                                            FlatButton(
                                                child: Center(
                                                    child: new Text("Close")),
                                                onPressed: () {
                                                  txtController.clear();
                                                  Navigator.pop(context);
                                                }),
                                          ],
                                        );
                                      },
                                    );
                                  }

                                },
                              ),
                            ),
                          ],
                        )
                      ]);
                },
              );
            },
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Semester(
                          batch: doc["BATCH"], branch: widget.branch)));
            },
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                    backgroundColor: Colors.red,
                    avatar: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(doc["BATCH"][4]),
                    ),
                    label: Text(
              doc["BATCH"],
              style: TextStyle(color: Colors.white, fontSize: 20),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Center(
                  child: new Text(
                    "Enter the Admin KEY",
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      maxLength: 4,
                      autofocus: false,
                      controller: code,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
// onSaved: (value) => url = value,
                      decoration: InputDecoration(
                        hintText: 'Key',
                        labelText: 'Your Admin Key',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.keyboard_control_sharp,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            child: new Text("Enter"),
                            onPressed: () {
                              if (code.text == key) {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        title: Center(
                                          child: new Text(
                                            "ADD BATCH",
                                          ),
                                        ),
                                        actions: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 80,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.25,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: 5,
                                                minLines: 1,
                                                controller: txtController,
                                                validator: (text) {
                                                  if (text == null ||
                                                      text.isEmpty) {
                                                    return 'Text is empty';
                                                  }
                                                  return null;
                                                },
// onSaved: (value) => url = value,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      '2019${widget.branch}',
                                                  labelText: 'BATCH',
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
                                                        .collection("BATCH")
                                                        .doc(widget.branch)
                                                        .collection(
                                                            widget.branch)
                                                        .doc(txtController.text
                                                            .toUpperCase())
                                                        .set({
                                                      "BATCH": txtController
                                                          .text
                                                          .toUpperCase(),
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
                                  },
                                );
                              } else {
                                code.clear();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      title: Center(
                                        child: new Text(
                                          "Wrong Key",
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                            child: Center(
                                                child: new Text("Close")),
                                            onPressed: () {
                                              txtController.clear();
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        label: Text("ADD NEW BATCH"),
        icon: const Icon(Icons.add_circle_rounded),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('BATCH')
            .doc(widget.branch)
            .collection(widget.branch)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Lottie.asset('assets/8370-loading.json'),
            );
          return Padding(
            padding: const EdgeInsets.fromLTRB(30, 150, 30, 150),
            child: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  color: Colors.black12,
                ),
                child: ListView(children: getExpenseItems(snapshot))),
          );
        },
      ),
    );
  }
}

class Semester extends StatefulWidget {
  final String batch;
  final String branch;

  Semester({required this.batch, required this.branch});

  @override
  _SemesterState createState() => _SemesterState();
}

class _SemesterState extends State<Semester> {
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => ListTile(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: Center(
                        child: new Text(
                          "DELETE SEMESTER",
                        ),
                      ),
                      actions: <Widget>[
                        Center(
                            child: Text(
                                "Enter Key To Delete ${doc["SEM"]}")),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: TextFormField(
                            maxLength: 4,
                            autofocus: false,
                            controller: code,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
// onSaved: (value) => url = value,
                            decoration: InputDecoration(
                              hintText: 'Key',
                              labelText: 'Your Admin Key',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(
                                Icons.keyboard_control_sharp,
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
                                child: new Text("DELETE"),
                                onPressed: () async {
                                  if (code.text == key) {
                                    FirebaseFirestore.instance
                                        .collection("SEMESTER")
                                        .doc(widget.batch)
                                        .collection(widget.batch)
                                        .doc("SEM${doc["SEM"][0]}")
                                        .delete();
                                    txtController.clear();
                                    Navigator.pop(context);
                                  } else {
                                    code.clear();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20.0),
                                          ),
                                          title: Center(
                                            child: new Text(
                                              "Wrong Key",
                                            ),
                                          ),
                                          actions: [
                                            FlatButton(
                                                child: Center(
                                                    child: new Text("Close")),
                                                onPressed: () {
                                                  txtController.clear();
                                                  Navigator.pop(context);
                                                }),
                                          ],
                                        );
                                      },
                                    );
                                  }

                                },
                              ),
                            ),
                          ],
                        )
                      ]);
                },
              );
            },
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Subject(
                          branch: widget.branch,
                          batch: widget.batch,
                          sem: doc["SEM"])));
            },
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                    backgroundColor: Colors.red,
                    avatar: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(doc["SEM"][0]),
                    ),
                    label: Text(
              doc["SEM"],
              style: TextStyle(color: Colors.white, fontSize: 20),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Center(
                  child: new Text(
                    "Enter the Admin Key",
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      maxLength: 4,
                      autofocus: false,
                      controller: code,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
// onSaved: (value) => url = value,
                      decoration: InputDecoration(
                        hintText: 'Key',
                        labelText: 'Your Admin Key',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.keyboard_control_sharp,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            child: new Text("Enter"),
                            onPressed: () {
                              if (code.text == key) {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        title: Center(
                                          child: new Text(
                                            "ADD SEMESTER",
                                          ),
                                        ),
                                        actions: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 80,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.25,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: 5,
                                                minLines: 1,
                                                controller: txtController,
                                                validator: (text) {
                                                  if (text == null ||
                                                      text.isEmpty) {
                                                    return 'Text is empty';
                                                  }
                                                  return null;
                                                },
// onSaved: (value) => url = value,
                                                decoration: InputDecoration(
                                                  hintText: '1ST SEMESTER',
                                                  labelText: 'SEMESTER',
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
                                                        .collection("SEMESTER")
                                                        .doc(widget.batch)
                                                        .collection(
                                                            widget.batch)
                                                        .doc(
                                                            "SEM${txtController.text.substring(0, 1)}")
                                                        .set({
                                                      "SEM": txtController.text
                                                          .toUpperCase(),
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
                                  },
                                );

                              } else {
                                code.clear();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      title: Center(
                                        child: new Text(
                                          "Wrong Key",
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                            child: Center(
                                                child: new Text("Close")),
                                            onPressed: () {
                                              txtController.clear();
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        label: Text("ADD NEW SEMESTER"),
        icon: const Icon(Icons.add_circle_rounded),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('SEMESTER')
            .doc(widget.batch)
            .collection(widget.batch)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Lottie.asset('assets/8370-loading.json'),
            );
          return Padding(
            padding: const EdgeInsets.fromLTRB(30, 150, 30, 150),
            child: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  color: Colors.black12,
                ),
                child: ListView(children: getExpenseItems(snapshot))),
          );
        },
      ),
    );
  }
}

class Subject extends StatefulWidget {
  final String branch;
  final String batch;
  final String sem;

  Subject({required this.branch, required this.batch, required this.sem});

  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => ListTile(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: Center(
                        child: new Text(
                          "DELETE SUBJECT",
                        ),
                      ),
                      actions: <Widget>[
                        Center(
                            child: Text(
                                "Enter Key To Delete Subject ${doc["SUB"]}")),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: TextFormField(
                            maxLength: 4,
                            autofocus: false,
                            controller: code,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
// onSaved: (value) => url = value,
                            decoration: InputDecoration(
                              hintText: 'Key',
                              labelText: 'Your Admin Key',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(
                                Icons.keyboard_control_sharp,
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
                                child: new Text("DELETE"),
                                onPressed: () async {
                                  if (code.text == key) {
                                    FirebaseFirestore.instance
                                        .collection("SUBJECT")
                                        .doc(widget.branch)
                                        .collection(widget.sem)
                                        .doc(doc["SUB"])
                                        .delete();
                                    txtController.clear();
                                    Navigator.pop(context);
                                  } else {
                                    code.clear();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20.0),
                                          ),
                                          title: Center(
                                            child: new Text(
                                              "Wrong Key",
                                            ),
                                          ),
                                          actions: [
                                            FlatButton(
                                                child: Center(
                                                    child: new Text("Close")),
                                                onPressed: () {
                                                  txtController.clear();
                                                  Navigator.pop(context);
                                                }),
                                          ],
                                        );
                                      },
                                    );
                                  }

                                },
                              ),
                            ),
                          ],
                        )
                      ]);
                },
              );
            },
            onTap: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MyApp(
                          branch: widget.branch,
                          batch: widget.batch,
                          sem: widget.sem,
                          sub: doc["SUB"])));
            },
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                backgroundColor: Colors.red,
                avatar: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(doc["SUB"][0]),
                ),
                label: Text(
                  doc["SUB"],
                  style: TextStyle(color: Colors.white, fontSize: 20),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Center(
                  child: new Text(
                    "Enter the Admin KEY",
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      maxLength: 4,
                      autofocus: false,
                      controller: code,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
// onSaved: (value) => url = value,
                      decoration: InputDecoration(
                        hintText: 'Key',
                        labelText: 'Your Admin Key',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.keyboard_control_sharp,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            child: new Text("Enter"),
                            onPressed: () {
                              if (code.text == key) {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        title: Center(
                                          child: new Text(
                                            "ADD SUBJECT",
                                          ),
                                        ),
                                        actions: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 80,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.25,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: 5,
                                                minLines: 1,
                                                controller: txtController,
                                                validator: (text) {
                                                  if (text == null ||
                                                      text.isEmpty) {
                                                    return 'Text is empty';
                                                  }
                                                  return null;
                                                },
// onSaved: (value) => url = value,
                                                decoration: InputDecoration(
                                                  hintText: 'Subject',
                                                  labelText: 'SUBJECT',
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
                                                        .collection("SUBJECT")
                                                        .doc(widget.branch)
                                                        .collection(widget.sem)
                                                        .doc(txtController.text
                                                            .toUpperCase())
                                                        .set({
                                                      "SUB": txtController.text
                                                          .toUpperCase(),
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
                                  },
                                );


                              } else {
                                code.clear();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      title: Center(
                                        child: new Text(
                                          "Wrong Key",
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                            child: Center(
                                                child: new Text("Close")),
                                            onPressed: () {
                                              txtController.clear();
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        label: Text("ADD NEW SUBJECT"),
        icon: const Icon(Icons.add_circle_rounded),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('SUBJECT')
            .doc(widget.branch)
            .collection(widget.sem)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Lottie.asset('assets/8370-loading.json'),
            );
          return Padding(
            padding: const EdgeInsets.fromLTRB(30, 150, 30, 150),
            child: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  color: Colors.black12,
                ),
                child: ListView(children: getExpenseItems(snapshot))),
          );
        },
      ),
    );
  }
}
