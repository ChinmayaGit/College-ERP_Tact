import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tact/main.dart';
import 'package:tact/modifiers/CappBar.dart';
import 'package:tact/notification/SChatpage.dart';
import 'package:tact/notification/notification.dart';
import 'package:tact/pdf/FileDownloader.dart';
import 'package:tact/pdf/load_pdf.dart';
import 'package:tact/pdf/pdfPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'BarCode.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _isLoading = true;


  late AnimationController _ColorAnimationController;

  // ignore: non_constant_identifier_names
  late AnimationController _TextAnimationController;
  late Animation _colorTween,
      _homeTween,
      _workOutTween,
      _iconTween,
      _drawerTween;

  int boxLength = 0;
  late String studentBatch;
  bool dataLoad = false;

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  late FirebaseMessaging messaging;
  late Widget _child;
  String appBarName = "home";

  @override
  void initState() {
    super.initState();
    _child = Center(
    child: Lottie.asset('assets/8370-loading.json'),
    );
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


    getSubscriptions();
    _ColorAnimationController =
        AnimationController(duration: Duration(seconds: 0), vsync: this);
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_ColorAnimationController);
    _iconTween =
        ColorTween(begin: Colors.white, end: Colors.lightBlue.withOpacity(0.5))
            .animate(_ColorAnimationController);
    _drawerTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_ColorAnimationController);
    _homeTween = ColorTween(begin: Colors.white, end: Colors.blue)
        .animate(_ColorAnimationController);
    _workOutTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_ColorAnimationController);
    _TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    // loadDocument();

    getDataStream();
  }

  int net = 0;

  void getDataStream() {
    print("chinu$net");
    net++;
    FirebaseFirestore.instance
        .collection("USERS")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {

      print(value.get("BRANCH"));
      FirebaseFirestore.instance
          .collection("USERS")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(value.get("BATCH"));
          studentBatch = value.get("BATCH");

          // getSubscriptions(studentBatch);

          FirebaseFirestore.instance
              .collection("SEMESTER")
              .doc(value.get("BATCH"))
              .collection(value.get("BATCH"))
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              boxLength = querySnapshot.docs.length;
              print(querySnapshot.docs.length);
              setState(() {
                dataLoad = true;
                _child =home();
              });
            });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    // getDataStream();
    super.dispose();
  }

   getSubscriptions() async{
   await FirebaseMessaging.instance.subscribeToTopic("NOTIFIER");

  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool scrollListener(ScrollNotification scrollInfo) {
    bool scroll = false;
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _ColorAnimationController.animateTo(scrollInfo.metrics.pixels / 80);

      _TextAnimationController.animateTo(scrollInfo.metrics.pixels);
      return scroll = true;
    }
    return scroll;
  }

  // loadDocument() async {
  //   document = await PDFDocument.fromAsset('assets/sample.pdf');
  //   setState(() => _isLoading = false);
  // }
  Widget image_carousel = new Container(
      child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: CarouselSlider(
      items: [
        'assets/Carousel2',
        'assets/Carousel1',
      ].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(color: Colors.transparent),
                child: GestureDetector(
                    child: Image.asset(i + ".PNG", fit: BoxFit.fill),
                    onTap: () async {
                      print(i);
                      OpenFile.open(i + ".pdf");
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => PdfPage(
                      //               path: "null",
                      //               name: "null",
                      //               assets: i + ".pdf",
                      //               assetsValue: true,
                      //             )));
                    }));
          },
        );
      }).toList(),
      options: CarouselOptions(
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    ),
  ));

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection("USERS")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get()
                      .then((value) {
                    print(value.get("BRANCH"));
                    // Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Sub(
                                  branch: value.get("BRANCH").toString(),
                                  sem: doc["SEM"].toString(),
                                )));
                  });
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Container(
                        margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
                        constraints: new BoxConstraints.expand(),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(height: 4.0),
                            new Text(
                              doc["SEM"],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            new Container(height: 10.0),
                            new Container(
                                margin: new EdgeInsets.symmetric(vertical: 8.0),
                                height: 2.0,
                                width: 18.0,
                                color: new Color(0xff00c6ff)),
                          ],
                        ),
                      ),
                      height: 124.0,
                      margin: new EdgeInsets.only(left: 46.0),
                      decoration: new BoxDecoration(
                        color: new Color(0xFF333366),
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: new Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 92.0,
                        width: 92.0,
                        margin: new EdgeInsets.symmetric(vertical: 16.0),
                        alignment: FractionalOffset.centerLeft,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/1.webp"),
                            fit: BoxFit.cover,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }
String gm="${FirebaseAuth.instance.currentUser!.email}";

  Widget notification() {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,elevation: 0,title: Text("Chat",style: TextStyle(color: Colors.black)),centerTitle: true,),

        body: Notifications(Batch: studentBatch,));
  }

  Widget home() {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: 250,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFF3366FF),
                        const Color(0xFF00CCFF),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  image_carousel,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 230,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.only(
                            bottomLeft: const Radius.circular(50.0),
                            bottomRight: const Radius.circular(50.0),
                          ),
                        ),
                        color: Colors.deepOrangeAccent,
                      ),
                      child: Center(
                          child: Text(
                            "SEMESTERS",
                            style: TextStyle(
                                color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ),
                  Container(
                    height: boxLength * 165,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('SEMESTER')
                          .doc(studentBatch)
                          .collection(studentBatch)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                              child: Lottie.asset(
                                  'assets/8370-loading.json'));
                        return ListView(

                          // shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: getExpenseItems(snapshot));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AnimatedAppBar(
          drawerTween: _drawerTween,
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          colorAnimationController: _ColorAnimationController,
          colorTween: _colorTween,
          homeTween: _homeTween,
          iconTween: _iconTween,
          workOutTween: _workOutTween,
          Batch: studentBatch,
        )
      ],
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          appBarName = "notification";
          _child = notification();

          break;
        case 1:
          appBarName = "home";
          _child = home();

          break;
        case 2:
          appBarName = "chat";
          _child = SChat(batch:studentBatch,);

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
    return dataLoad == true
        ? Scaffold(

        key: scaffoldKey,
        drawer: Drawer(
          child: Container(

            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Column(

                    children: [
                      CircleAvatar(

                        maxRadius: 35,
                        backgroundColor: Colors.brown.shade800,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height:40,
                            width: 100,
                            child: Center(
                              child: Text(
                                "👤",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 40),
                              ),
                            ),
                          ),
                        ),
                      ),


                      Text(
                       " ${gm.substring(0, gm.length - 10)}",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        " ${studentBatch.substring(4, studentBatch.length - 0)}",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        " ${studentBatch.substring(0, studentBatch.length - 3)}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(color: Colors.deepOrange),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.indigo,   size: 30,
                  ),
                  title: Text("Home"),
                  onTap: () {

                  },
                ),
                ListTile(
                  title: Text(
                    'Library M',
                    style: TextStyle(
                        color: Colors.blueGrey[600],
                    ),
                  ),
                  leading: Icon(
                    Icons.book_outlined,
                    color: Colors.green.shade500,
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => BarCodeScanner()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.playlist_add_check_rounded, color: Colors.blueAccent,   size: 30,),
                  title: Text("ToDo S/T"),
                  onTap: () {

                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_outline_rounded, color: Colors.blueAccent,   size: 30,),
                  title: Text("Info"),
                  onTap: () {

                  },
                ),

                // ListTile(
                //   leading: Icon(Icons.category, color: Colors.amber,   size: 30,),
                //   title: Text("Category"),
                //   onTap: () {
                //
                //   },
                // ),
                //
                // ListTile(
                //   leading: Icon(Icons.local_police_outlined, color: Colors.deepPurpleAccent,   size: 30,),
                //   title: Text("Policy"),
                //   onTap: () {
                //   },
                // ),

                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red,   size: 30,),
                  title: Text("Log out"),
                  onTap: () async {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                MyApp(payload: "payload",)));
                  },
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Color(0xFFEEEEEE),
        bottomNavigationBar: FluidNavBar(
          // (1)

          icons: [
            FluidNavBarIcon(
                icon: Icons.notifications_active_outlined,
                backgroundColor: Colors.green,
                selectedForegroundColor: Colors.white,
                unselectedForegroundColor: Colors.white), // (2)
            FluidNavBarIcon(
                icon: Icons.home_outlined,
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
        body: _child) : Center(
      child: Lottie.asset('assets/8370-loading.json'),
    );
  }
}

class Sub extends StatefulWidget {
  final String branch;
  final String sem;

  Sub({
    required this.branch,
    required this.sem,

  });

  @override
  _SubState createState() => _SubState();
}

class _SubState extends State<Sub> {

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection("USERS")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get()
                      .then((value) {
                    print(value.get("BATCH"));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PageLoader(
                                batch: value.get("BATCH").toString(),
                                sem: widget.sem,
                                sub: doc["SUB"])));
                  });
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Container(
                        margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
                        constraints: new BoxConstraints.expand(),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(height: 4.0),
                            new Text(
                              doc["SUB"],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            new Container(height: 10.0),
                            new Container(
                                margin: new EdgeInsets.symmetric(vertical: 8.0),
                                height: 2.0,
                                width: 18.0,
                                color: new Color(0xff00c6ff)),
                          ],
                        ),
                      ),
                      height: 124.0,
                      margin: new EdgeInsets.only(left: 46.0),
                      decoration: new BoxDecoration(
                        color: new Color(0xFF333366),
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: new Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 92.0,
                        width: 92.0,
                        margin: new EdgeInsets.symmetric(vertical: 16.0),
                        alignment: FractionalOffset.centerLeft,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/1.webp"),
                            fit: BoxFit.cover,
                          ),

                          // child: new Image(
                          //   image: AssetImage("assets/1.webp"),
                          //   height: 92.0,
                          //   width: 92.0,
                          // ),
                        )),
                  ],
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "SUBJECTS",
          style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20),
        ),
        centerTitle: true,
      ),

      body:
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('SUBJECT')
            .doc(widget.branch)
            .collection(widget.sem)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: Lottie.asset('assets/8370-loading.json'));
          return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: getExpenseItems(snapshot));
        },
      ),

    );
  }
}
