import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tact/HomePage.dart';

const debug = false;
bool time=false;
Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: debug);
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(new NeumorphicApp(
    title: "Auth Demo",
    themeMode: ThemeMode.light,
    theme: NeumorphicThemeData(
      baseColor: Color(0xFFFFFFFF),
      lightSource: LightSource.topLeft,
      depth: 10,
    ),
    darkTheme: NeumorphicThemeData(
      baseColor: Color(0xFF3E3E3E),
      lightSource: LightSource.topLeft,
      depth: 6,
    ),
    home: MyApp(payload: "payload",),
  ));
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class MyApp extends StatefulWidget {
  final String payload;


  MyApp({required this.payload});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }
  @override
  void initState() {
    super.initState();
    requestPermission(Permission.manageExternalStorage);
    requestPermission(Permission.storage);
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
              context, MaterialPageRoute(builder: (_) => HomePage()));
        }
      });
    });
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);



  }
  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => MyApp(payload:payload!,)),
    );
  }
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  // TextEditingController createEmailController = new TextEditingController();
  // TextEditingController createPasswordController = new TextEditingController();
  bool setTime = true;
  final _firestore = FirebaseFirestore.instance;
  bool isHidden=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: setTime == true
          ? Center(
              child: Lottie.asset('assets/8370-loading.json'),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Lottie.asset('assets/67934-studyly.json'),

                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "TACT",
                    style: TextStyle(fontFamily: 'Demode', fontSize: 45),
                  ),
                  NeumorphicButton(
                      margin: EdgeInsets.only(top: 12),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              backgroundColor: Colors.transparent,
                              title: Center(
                                child: new Text(
                                  "TACT",style: TextStyle(color: Colors.white),
                                ),
                              ),
                              actions: <Widget>[
                                Center(
                                  child: Image.asset("assets/images/college-building-icon-60.png",
                                    ),
                                ),
                                Text(
                                  "Work On Progress.",
                                  style: TextStyle(color: Colors.white, fontSize: 25),
                                ),
                                FlatButton(
                                  child: new Text("Close",style: TextStyle(color: Colors.white),),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),

                              ],
                            );
                          },
                        );
                      },
                      style: NeumorphicStyle(

                        shape: NeumorphicShape.convex,
                        boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Just To Vist Collage",
                        style: TextStyle(color: _textColor(context)),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text("  OR\nLogin"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(

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
                        labelText: 'College ID',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.mail_outline,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(

                      controller: passwordController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
// onSaved: (value) => url = value,
                      obscureText:  isHidden?true:false,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              if( isHidden==true){isHidden =false;}else{isHidden =true;}

                            });
                          },
                          child: Icon(
                            isHidden?
                            Icons.visibility_off:
                            Icons.visibility,color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),


                  time==true?CircularProgressIndicator():NeumorphicButton(
                      margin: EdgeInsets.only(top: 12),
                      onPressed: () {
                        signInWithEmail();
                        setState(() {
                          time=true;
                        });
                      },
                      style: NeumorphicStyle(

                        shape: NeumorphicShape.convex,
                        boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Login 👥",
                        style: TextStyle(color: _textColor(context)),
                      )),
SizedBox(height: 80,)

                ],
              ),
            ),
    );
  }

  Color _iconsColor(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    if (theme!.isUsingDark) {
      return theme.current!.accentColor;
    } else {
      return theme.current!.accentColor;
    }
  }

  Color _textColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
  Future<User?> getUser() async {
    return _auth.currentUser;
  }

  void signInWithEmail() async {

    // marked async
    UserCredential user;
    try {
      user = (await _auth.signInWithEmailAndPassword(
          email: "${emailController.text}@gmail.com", password: passwordController.text));
      final deviceToken = await FirebaseMessaging.instance.getToken();

        print("token1");
        FirebaseFirestore.instance
            .collection('USERS')
            .doc(user.user!.uid)
            // .collection('TOKEN')
            // .doc(deviceToken)
            .update({
          'TOKEN': deviceToken,
          'PLATFORM': Platform.operatingSystem,
        });

      var firebaseUser =  FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection('USERS').doc(firebaseUser!.uid).get().then((value){

        FirebaseFirestore.instance
            .collection('TOKEN_REC')
            .doc(value.data()!["BRANCH"])
        .collection(value.data()!["BATCH"])
        .doc(deviceToken)
            .set({
       "none":"",
        });
      });
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
      setState(() {
        time=false;
      });
    } catch (e) {
      setState(() {
        time=false;
      });
      print(e.toString());
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
  }
}
