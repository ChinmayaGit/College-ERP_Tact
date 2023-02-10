import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tact/main.dart';
import 'package:tact/notification/notification.dart';

class AnimatedAppBar extends StatelessWidget {
  AnimationController colorAnimationController;
  Animation colorTween, homeTween, workOutTween, iconTween, drawerTween;
  Function onPressed;
  String Batch;

  AnimatedAppBar({

    required this.colorAnimationController,
    required this.onPressed,
    required this.colorTween,
    required this.homeTween,
    required this.iconTween,
    required this.drawerTween,
    required this.workOutTween,
    required this.Batch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: AnimatedBuilder(
        animation: colorAnimationController,
        builder: (context, child) => AppBar(
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.dehaze,
          //     color: drawerTween.value,
          //   ),
          //   // onPressed: onPressed,
          // ),
          backgroundColor: colorTween.value,
          elevation: 0,
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "TACT ",
                style: TextStyle(
                    color: homeTween.value,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            MyApp(payload: "payload",)));
              },
              icon: Icon(Icons.exit_to_app),
            )
            // Padding(
            //   padding: const EdgeInsets.all(7),
            //   child: CircleAvatar(
            //     backgroundImage:
            //     NetworkImage('image_url'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
