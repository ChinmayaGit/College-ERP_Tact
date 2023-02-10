import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tactadmin/appDrawer.dart';
import 'package:url_launcher/url_launcher.dart';


class Upload extends StatefulWidget {
  final String branch;
  final String batch;
  final String sem;
  final String sub;
  final String name;
  Upload({required this.branch, required this.batch, required this.sem,required this.sub,required this.name});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController urlController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool setTime = true;
  String _chosenValue ='pdf';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        sub: widget.sub,
        batch: widget.batch,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("ADMIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.asset(
                    "assets/images.jpg",
                    fit: BoxFit.cover,
                  )),
              actions: [
                // IconButton(
                //   onPressed: () {
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (_) => Branch(edit: false)));
                //   },
                //   icon: Icon(Icons.edit_outlined),
                // ),
                IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);

                  },
                  icon: Icon(Icons.exit_to_app),
                )
              ],
            ),
          ];
        },
        body: SingleChildScrollView(

          child: Center(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        launch("https://drive.google.com/drive/u/0/my-drive");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueAccent,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(30))),
                          height: 80,
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset("assets/gdrive.png"),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        launch("https://sites.google.com/site/gdocs2direct/");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueAccent,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(30))),
                          height: 80,
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/link.png",
                              height: 100,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: urlController,
                    validator: (value) {
                      if (value!.isEmpty) return 'This field cannot be empty';
                      return null;
                    },
// onSaved: (value) => url = value,
                    decoration: InputDecoration(
                      hintText: 'Full Url link',
                      labelText: 'Url',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.add_link,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonHideUnderline(
                        child:
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.purpleAccent,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))

                          ),
                          child: Center(
                            child:  DropdownButton<String>(
                              focusColor:Colors.white,
                              value: _chosenValue,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),
                              iconEnabledColor:Colors.black,
                              items: <String>[
                                'pdf',
                                'docx',
                                'pptx',
                                'xlsx',
                                'doc',
                                'ppt',
                                'xls',
                                // '.jpg',
                                // '.png',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,textAlign: TextAlign.center,style:TextStyle(color:Colors.black),),
                                );
                              }).toList(),
                              hint:Text(
                                "pl",textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _chosenValue = value!;
                                });
                              },
                            ),
                          ),
                        ),

                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) return 'This field cannot be empty';
                            return null;
                          },
// onSaved: (value) => url = value,
                          decoration: InputDecoration(
                            hintText: '$_chosenValue Name',
                            labelText: '$_chosenValue Name',
                            border: OutlineInputBorder(),
                            // icon: Icon(Icons.book),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),



                SizedBox(
                  height: 20,
                ),
                setTime == false
                    ? Center(
                  child: Lottie.asset('assets/8341-uploading.json',
                      height: 60, width: 100),
                )
                    : GestureDetector(
                  onTap: () {
// messageTextContoller.clear();

                    setState(() {
                      setTime = false;
                    });
                    Timer(Duration(seconds: 2), () {
                      setState(() {
                        setTime = true;
                      });
                    });
                    FirebaseFirestore.instance
                        .collection("DOCUMENTS")
                    // .doc(batch)
                    // .collection(sem)
                        .doc(nameController.text)
                        .set({
                      "LINK": urlController.text,
                      "PDF": "${nameController.text}.$_chosenValue",
                      "BRANCH": widget.branch,
                      "BATCH": widget.batch,
                      "SEMESTER": widget.sem,
                      "SUBJECT": widget.sub,
                      "TEACHER_NAME": widget.name,
                      "UID": FirebaseAuth.instance.currentUser!.uid,
                      "DATE": DateTime.now(),
                    });
                    // Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) =>
                    //             MyHomePage()));
                    setState(() {
                      nameController.clear();
                      urlController.clear();
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 150,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(50.0),
                          bottomRight: const Radius.circular(50.0),
                        ),
                      ),
                      color: Colors.deepOrangeAccent,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Upload",
                          style:
                          TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.send,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
