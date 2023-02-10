import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tactadmin/HomePage.dart';
import 'package:tactadmin/Login/SignUp.dart';
import 'package:tactadmin/filters/filters.dart';

const debug = true;

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(Phoenix(
    child: MaterialApp(
      title: "Auth Demo",
      home: Branch(),
    ),
  ));
}

// Future<Null> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(new MaterialApp(
//     title: "Auth Demo",
//     home: Branch(),
//   ));
// }

final FirebaseAuth _auth = FirebaseAuth.instance;

class MyApp extends StatefulWidget {
  final String branch;
  final String batch;
  final String sem;
  final String sub;

  MyApp(
      {required this.branch,
      required this.batch,
      required this.sem,
      required this.sub});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController name = new TextEditingController();
  bool setTime = true;
  bool setLogin = false;
  final _firestore = FirebaseFirestore.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    Timer(Duration(seconds: 4), () {
      setState(() {
        setTime = false;
      });
    });
    Timer(Duration(seconds: 2), () {
      getUser().then((user) {
        if (user != null) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => MyHomePage()));
        }
      });
    });
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => Branch()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: setTime == true
          ? Center(
              child: Lottie.asset('assets/8370-loading.json'),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Lottie.asset('assets/67931-studyly.json'),
                  // SizedBox(height: 40,),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: GestureDetector(
                  //
                  //       onTap: (){
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute<void>(builder: (context) => SignUp()),
                  //         );
                  //       },
                  //       child: Container(
                  //         decoration: ShapeDecoration(
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: new BorderRadius.circular(40.0),
                  //             ),color: Colors.lightBlueAccent
                  //         ),
                  //
                  //         child: Padding(
                  //           padding: const EdgeInsets.fromLTRB(30.0,10,30,10),
                  //           child: Text("Create Account: \nAdmin/Students",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  //         ),)),
                  // ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Admin Login",
                        style: TextStyle(
                            fontFamily: 'Demode',
                            fontSize: 20,
                            color: Colors.purpleAccent),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      autofocus: false,
                      controller: name,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
// onSaved: (value) => url = value,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        labelText: 'Your Name',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.person,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      autofocus: false,
                      controller: emailController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
// onSaved: (value) => url = value,
                      decoration: InputDecoration(
                        hintText: 'ID',
                        labelText: 'ADMIN ID',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.account_circle_outlined,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      autofocus: false,
                      controller: passwordController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
// onSaved: (value) => url = value,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.password,
                        ),
                      ),
                    ),
                  ),

                  setLogin == false
                      ? Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: GestureDetector(
                            onTap: () {
                              // signUpWithEmail();
                              signInWithEmail();
                              setState(() {
                                setLogin = true;
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
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
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
                        )
                      : Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
    );
  }

  Future<User?> getUser() async {
    return _auth.currentUser;
  }

  // getAdmin() {
  //   double pricecal = 0;
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .snapshots()
  //       .listen((event) {
  //     for (var i = 0; i < event.docs.length; i++) {
  //       print(event.docs[i]["product_subtotal"]);
  //       pricecal += event.docs[i]["product_subtotal"];
  //     }
  //   });
  //   return pricecal;
  // }
  void signInWithEmail() async {
    // marked async
    print("hellome");
    print(widget.branch);
    print(widget.batch);
    final deviceToken = await FirebaseMessaging.instance.getToken();
    print("hellome");
    print(deviceToken);

    UserCredential user;
    if (name.text.length >= 3) {
      try {
        user = (await _auth
            .signInWithEmailAndPassword(
                email: "${emailController.text}@gmail.com",
                password: passwordController.text)
            .then((value) {
          FirebaseFirestore.instance
              .collection("USERS")
              .doc(value.user!.uid)
              .get()
              .then((value) {
            print(value.get("ADMIN"));
            if (value.get("ADMIN") == true) {
              FirebaseFirestore.instance
                  .collection("USERS")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("TEACHER")
                  .doc("INFO")
                  // .doc(widget.batch+widget.sem)
                  .set({
                "BRANCH": widget.branch,
                "BATCH": widget.batch,
                "SEM": widget.sem,
                "SUB": widget.sub,
                "NAME": name.text,
                "TIME": DateTime.now(),
                'TOKEN': deviceToken,
              });

              Navigator.popUntil(
                  context, ModalRoute.withName(Navigator.defaultRouteName));
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MyHomePage()));
            } else {
              FirebaseAuth.instance.signOut();
              setState(() {
                setLogin = false;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    actions: <Widget>[
                      Center(
                        child: Lottie.asset(
                          'assets/7308-empty.json',
                          width: 100.0,
                          height: 80.0,
                        ),
                      ),
                      Text(""),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                            child: Text(
                          "You Are Not A Admin",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        )),
                      ),
                      FlatButton(
                        child: new Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          });
          return value;
        }));
      } catch (e) {
        print(e.toString());
        setState(() {
          setLogin = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              actions: <Widget>[
                Center(
                  child: Lottie.asset(
                    'assets/7308-empty.json',
                    width: 100.0,
                    height: 80.0,
                  ),
                ),
                Text(""),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                      child: Text(
                    "Email or password Must Be Invalid",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  )),
                ),
                FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } finally {
        // if (user != null) {
        //   // sign in successful!
        //   // ex: bring the user to the home page
        //   print("chinuin");
        // } else {
        //   print("chinuout");
        //   // sign in unsuccessful
        //   // ex: prompt the user to try again
        // }
      }
    } else {
      setState(() {
        setLogin = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            actions: <Widget>[
              Center(
                child: Lottie.asset(
                  'assets/7308-empty.json',
                  width: 100.0,
                  height: 80.0,
                ),
              ),
              Text(""),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                    child: Text(
                  "Name Must be greater than 3 letters",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                )),
              ),
              FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  setState(() {
                    setLogin = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
