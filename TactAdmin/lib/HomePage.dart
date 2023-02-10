import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:tactadmin/Chat.dart';
import 'package:tactadmin/EditFilter.dart';
import 'package:tactadmin/Login/SignUp.dart';
import 'package:tactadmin/Upload.dart';
import 'package:tactadmin/appDrawer.dart';
import 'package:tactadmin/chatSelector.dart';
import 'package:tactadmin/filters/filters.dart';
import 'package:tactadmin/main.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final firestore = FirebaseFirestore.instance;


  // final TextEditingController _subController = TextEditingController();
  // final TextEditingController _teachController = TextEditingController();


  late String branch;
  late String batch;
  late String sem;
  late String sub;
  late String name;

  late FirebaseMessaging messaging;
  bool dataAvi = false;
  late Widget _child;
  String appBarName = "Upload";

  @override
  void initState() {

    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    firestore
        .collection("USERS")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("TEACHER")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        branch = result.get("BRANCH");
        batch = result.get("BATCH");
        sem = result.get("SEM");
        sub = result.get("SUB");
        name = result.get("NAME");
        _child = Upload(sem:sem, sub: sub, name: name, branch: branch, batch: batch);
      });
    }).then((value) {
      setState(() {
        dataAvi = true;
      });
    });
  }



  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          appBarName = "Account";
          _child = Upload(sem:sem, sub: sub, name: name, branch: branch, batch: batch);

          break;
        case 1:
          appBarName = "Upload";
          _child = Upload(sem:sem, sub: sub, name: name, branch: branch, batch: batch);

          break;
        case 2:
          appBarName = "Message";
          _child = ChatSelect(batch: batch,sem: sem,sub: sub,);

          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return dataAvi == true
        ? Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CustomDrop()));
              },
              child: Icon(Icons.edit_outlined),
            ),
            extendBody: true,
            bottomNavigationBar: FluidNavBar(
              // (1)

              icons: [
                FluidNavBarIcon(
                    icon: Icons.supervisor_account_outlined,
                    backgroundColor: Colors.green,
                    selectedForegroundColor: Colors.white,
                    unselectedForegroundColor: Colors.white), // (2)
                FluidNavBarIcon(
                    icon: Icons.upload_outlined,
                    backgroundColor: Colors.red,
                    selectedForegroundColor: Colors.white,
                    unselectedForegroundColor: Colors.white), // (3)
                FluidNavBarIcon(
                    icon: Icons.message_outlined,
                    backgroundColor: Colors.blue,
                    selectedForegroundColor: Colors.white,
                    unselectedForegroundColor: Colors.white),
              ],
              style: FluidNavBarStyle(
                iconUnselectedForegroundColor: Colors.black12,
                barBackgroundColor: Colors.black,
              ),
              onChange: _handleNavigationChange,
              defaultIndex: 1, // (4)
            ),

            body: _child)
        : Center(child: CircularProgressIndicator());
  }



}
