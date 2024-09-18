import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; // Assurez-vous d'avoir Cloud Firestore configuré
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jymu/UserManager.dart';
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/init_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../../Models/UserModel.dart';
import 'AuthPage.dart';
import 'LoginPage.dart';

class EmailVerif extends StatefulWidget {

  @override
  _EmailVerifState createState() => _EmailVerifState();
}

class _EmailVerifState extends State<EmailVerif> {

  bool verif = false;

  User? user = FirebaseAuth.instance.currentUser;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user!.reload();
        setState(() {
          if (user!.emailVerified) {
            verif = true;
            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.redAccent,
            Colors.deepOrange,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          SizedBox(height: 15,),
          Text(
            user?.email ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Container(
            padding: EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F5F8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(38.0),
                topRight: Radius.circular(38.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Verifie ton",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 28),
                          ),
                              Text(
                                "Email",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 28),
                              ),
                              Image.asset(
                                "assets/images/emoji_pc.png",
                                height: 38,
                              ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                  Text(
                      "Ouvre ta boite mail (verifie les spams)",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18, color: Colors.red),
                    ),


                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTapUp: (t) async {
                          if (verif) {
                            await createProfile(user);
                            UserModel.currentUser().fetchUserData();
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context) => InitScreen()),
                            );
                          } else {
                            user?.sendEmailVerification();
                          }
                        },
                        child: Container(
                          height: 70,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
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
                              if(!verif)
                                Text(
                                  "Renvoyer",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                                ),
                              if(verif)
                                Text(
                                  "Suivant",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                                ),
                              if(verif)
                                SizedBox(width: 15,),
                              if(verif)
                                Icon(CupertinoIcons.arrow_right, color: Colors.white, size: 20,)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Trompé d'informations ? ",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16, color: CupertinoColors.systemGrey),
                      ),
                      SizedBox(width: 5,),
                      GestureDetector(
                          onTapUp: (t) async {
                            user = FirebaseAuth.instance.currentUser;
                            user?.delete();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(body: UsernamePage(),),
                              ),
                            );
                          },
                          child: Text(
                            "Recommencer",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16, color: Colors.deepPurpleAccent),
                          ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
