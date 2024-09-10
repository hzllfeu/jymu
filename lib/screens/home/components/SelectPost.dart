import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/UserManager.dart';
import 'package:jymu/screens/home/PostWidget.dart';
import 'package:jymu/screens/home/camera.dart';

import '../../InputPage.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class SelectPost extends StatefulWidget {

  static String routeName = "/";

  @override
  State<SelectPost> createState() => _SelectPostState();
}

class _SelectPostState extends State<SelectPost> {

  @override
  void initState() {
    super.initState();
    Haptics.vibrate(HapticsType.light);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            Container(
              width: 50,
              height: 6,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTapUp: (t) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(),
                  ),
                );
              },
              child: Container(
                  height: MediaQuery.of(context).size.height*0.09,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xffF14BA9), Colors.redAccent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffF14BA9).withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Poster un training",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15,),
                      Container(
                        height: 30,
                        width: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.camera_rotate_fill,
                            size: 18,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTapUp: (t) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewPostWidget(),
                  ),
                );
              },
              child: Container(
                  height: MediaQuery.of(context).size.height*0.075,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.redAccent,
                        Colors.deepOrange,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffF14BA9).withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Faire un post",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15,),
                      Container(
                        height: 30,
                        width: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.text_aligncenter,
                            size: 18,
                            color: Colors.black.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
