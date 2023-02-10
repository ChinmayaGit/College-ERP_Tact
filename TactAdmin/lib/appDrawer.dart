import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tactadmin/BarCode.dart';

class AppDrawer extends StatefulWidget {

  final String batch;
  final String sub;

  AppDrawer({required this.batch,required this.sub,});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  var txtController = TextEditingController();
  var imgController = TextEditingController();

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: Colors.deepOrange.shade400,
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 3,
            // height: 233,
            child: DrawerHeader(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            100,
                          ),
                        ),
                        child: Center(
                          child: InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (ctx) => Profile(),
                                //     ));
                              },
                              child:
                              // user?.photoURL != null
                              //     ?
                              ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(150.0),
                                  child: Container(
                                      height: 80,
                                      width: 80,
                                      color: Colors.white24,
                                      child: Icon(
                                        Icons.android,
                                        size: 40,
                                        color: Colors.green.shade400,
                                      )))
                            //     : IconButton(
                            //   onPressed: () {},
                            //   icon:
                            //   Icon(Icons.person, color: Colors.white),
                            //   iconSize: 50,
                            // ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 10.0),
                        child: Text(
                          "${"${FirebaseAuth.instance.currentUser!.email}".substring(0,"${FirebaseAuth.instance.currentUser!.email}".length - 10)}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Canterbury'),
                        ),
                      )
                    ],
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: EdgeInsets.only(top: 10.0, left: 10.0),
                  //       child: Text(
                  //         user.email != null ? user.email : "",
                  //         style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 14.0,
                  //             fontWeight: FontWeight.w400,
                  //             fontFamily: 'Canterbury'),
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Notifier',
              style: TextStyle(
                  color: Colors.blueGrey[600],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Canterbury'),
            ),
            leading: Icon(
              Icons.notifications_active,
              color: Colors.blueAccent.shade700,
              size: 30,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: new Text(
                        "Send Notification",
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
                                hintText: 'Text',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width / 1.25,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              controller: imgController,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Img link is empty';
                                }
                                return null;
                              },
// onSaved: (value) => url = value,
                              decoration: InputDecoration(
                                hintText: 'Img link',
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
                                    imgController.clear();
                                    Navigator.pop(context);
                                  }),
                            ),
                            Expanded(
                              child: FlatButton(
                                child: new Text("Sent"),
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection("NOTIFIER")
                                      .add({
                                    "TOPIC": widget.batch,
                                    "MSG": txtController.text,
                                    "SUB": widget.sub,
                                    "IMAGE": imgController.text,
                                    "TIME":DateTime.now(),
                                  });
                                  txtController.clear();
                                  imgController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        )
                      ]);
                },
              );
            },
          ),
          ListTile(
            title: Text(
              'Library M',
              style: TextStyle(
                  color: Colors.blueGrey[600],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Canterbury'),
            ),
            leading: Icon(
              Icons.book_outlined,
              color: Colors.blueAccent.shade700,
              size: 30,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => BarCodeScanner()));
            },
          ),
          ListTile(
            title: Text(
              'About US',
              style: TextStyle(
                  color: Colors.blueGrey[600],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Canterbury'),
            ),
            leading: Icon(
              Icons.info,
              color: Colors.blueAccent.shade700,
              size: 30,
            ),
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => AboutUs(
              //           page: 'about',
              //         )));
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(
                  color: Colors.blueGrey[600],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Canterbury'),
            ),
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
              size: 30,
            ),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pop(context);
              // Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
