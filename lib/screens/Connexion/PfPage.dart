import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; // Assurez-vous d'avoir Cloud Firestore configuré
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'AuthPage.dart';
import 'LoginPage.dart';

class PfPage extends StatefulWidget {
  final String username;

  const PfPage({super.key, required this.username});

  @override
  _PfPageState createState() => _PfPageState();
}

class _PfPageState extends State<PfPage> {
  File? _image;

  Future<void> _pickImage() async {
    // Charger une image depuis les assets en tant que substitution
    final byteData = await rootBundle.load('assets/images/kevin.jpg');
    final file = File('${(await getTemporaryDirectory()).path}/kevin.jpg');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    setState(() {
      _image = file;
    });

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
          if(_image != null)
            Image.file(_image!, height: 80, width: 80,),
          SizedBox(height: 15,),
          Text(widget.username, style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700),),
          SizedBox(height: 170,),
          Container(
            padding: EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height / 1.9,
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
                            "Choisi une",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 28),
                          ),
                              Text(
                                "photo de profil",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 28),
                              ),
                              Image.asset(
                                "assets/images/emoji_photo.png",
                                height: 38,
                              ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  GestureDetector(
                    onTapUp: (t){
                      _pickImage();
                    },
                    child: Text(
                      "Ouvrir la galerie",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18, color: Colors.red),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTapUp: (t) {
                          if (_image != null) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context) => Scaffold(body:  AuthPage(username: widget.username, profileimage: _image!),)),
                            );
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
                              Text(
                                "Suivant",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                              ),
                              SizedBox(width: 15,),
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
                        "Tu as deja un compte ? ",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16, color: CupertinoColors.systemGrey),
                      ),
                      SizedBox(width: 5,),
                      GestureDetector(
                        onTapUp: (t){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(body: LoginPage(),),
                            ),
                          );
                        },
                        child: Text(
                          "Se connecter",
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
