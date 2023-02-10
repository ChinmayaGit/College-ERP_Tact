import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tactadmin/HomePage.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var select, select1;
  TextEditingController createEmailController = new TextEditingController();
  TextEditingController createPasswordController = new TextEditingController();
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  String changeListener = "BRANCH";
  String changeListener1 = "BATCH";
  bool admin = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<User?> getUser() async {
  //   return _auth.currentUser;
  // }
  void signUpWithEmail() async {
    UserCredential user;

    try {
      user = await _auth.createUserWithEmailAndPassword(
        email: "${createEmailController.text}@gmail.com",
        password: createPasswordController.text,
      );
      FirebaseFirestore.instance.collection("USERS").doc(user.user!.uid).set({
        "GMAIL": "${createEmailController.text}@gmail.com",
        "PASS": createPasswordController.text,
        "TIME": DateTime.now(),
        "USER_ID": user.user!.uid,
        "ADMIN": admin,
        "BATCH": changeListener1,
        "BRANCH": changeListener,
      }).then((value) {
        FirebaseAuth.instance.signOut();
      });

      Navigator.pop(context);

      Navigator.push(context, MaterialPageRoute(builder: (_) => MyHomePage()));
    } catch (e) {
      print(e.toString());
    } finally {
      // if (user != null) {
      //   // sign in successful!
      //   // ex: bring the user to the home page
      // } else {
      //   // sign in unsuccessful
      //   // ex: prompt the user to try again
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "CREATE ACCOUNT",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Form(
            key: _formKeyValue,
            autovalidate: true,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: false,
                    controller: createEmailController,
                    validator: (value) {
                      if (value!.isEmpty) return 'This field cannot be empty';
                      return null;
                    },
// onSaved: (value) => url = value,
                    decoration: InputDecoration(
                      hintText: 'ID',
                      labelText: 'Create ID',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.account_circle_outlined,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: false,
                    controller: createPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) return 'This field cannot be empty';
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
                Material(
                  elevation: 20,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(flex: 2, child: SizedBox()),
                        admin == true
                            ? Expanded(
                                flex: 1,
                                child: Text(
                                  "Teacher",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ))
                            : Text(
                                "Student",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                        Expanded(
                          flex: 2,
                          child: CupertinoSwitch(
                            activeColor: Colors.green,
                            trackColor: Colors.black45,
                            value: admin,
                            onChanged: (bool value) {
                              setState(() {
                                admin = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                admin == false
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("BRANCH")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Text("Loading.....");
                          else {
                            var items = <String>[];
                            for (int i = 0;
                                i < snapshot.data!.docs.length;
                                i++) {
                              DocumentSnapshot snap = snapshot.data!.docs[i];
                              items.add(snap.id);
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  child: Material(
                                    elevation: 20,
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        items: items
                                            .map((value) => DropdownMenuItem(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: Text(value,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                  value: value,
                                                ))
                                            .toList(),
                                        onChanged: (currencyValue) {


                                          setState(() {
                                            select = currencyValue;
                                          });
                                          changeListener =
                                              currencyValue.toString();
                                        },
                                        value: select,
                                        isExpanded: false,
                                        hint: Center(
                                          child: new Text(" BRANCH",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        })
                    : Container(),
                SizedBox(
                  height: 30,
                ),
                changeListener != "BRANCH" && admin == false
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("BATCH")
                            .doc(changeListener)
                            .collection(changeListener)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Text("Loading.....");
                          else {
                            var item = <String>[];
                            for (int i = 0;
                                i < snapshot.data!.docs.length;
                                i++) {
                              DocumentSnapshot snap = snapshot.data!.docs[i];
                              item.add(snap.id);
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  child: Material(
                                    elevation: 20,
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        items: item
                                            .map((value) => DropdownMenuItem(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: Text(value,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                  value: value,
                                                ))
                                            .toList(),
                                        onChanged: (currencyValue) {

                                          setState(() {
                                            select1 = currencyValue;
                                          });
                                          changeListener1 =
                                              currencyValue.toString();
                                        },
                                        value: select1,
                                        isExpanded: false,
                                        hint: Center(
                                          child: new Text(" BATCH",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        })
                    : Container(),
                SizedBox(
                  height: 30,
                ),
                changeListener != "BRANCH" || admin == true
                    ? Center(
                        child: GestureDetector(
                          onTap: () {
                            // signUpWithEmail();
                            Navigator.pop(context);
                            signUpWithEmail();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                color: Colors.deepOrangeAccent,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "AddData",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            )));
  }
}
