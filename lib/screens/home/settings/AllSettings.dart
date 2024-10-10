import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jymu/Models/UserModel.dart';
import 'package:jymu/UserManager.dart';
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/home/ModifyTags.dart';

import '../../InputPage.dart';
import 'NotifiSettings.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class AllSettings extends StatefulWidget {

  const AllSettings({super.key});

  static String routeName = "/";

  @override
  State<AllSettings> createState() => _AllSettingsState();
}

class _AllSettingsState extends State<AllSettings> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  late Map<String, dynamic> data;
  bool done = false;
  late String id;
  late String displayname = "";
  late String bio = "";
  late List<dynamic> tags;

  Map<String, bool> notifs = {"allnotifs":false, "likenotif": false, "comnotif": false, "abonotif": false};


  @override
  void initState() {
    super.initState();
    id = UserModel.currentUser().id!;
    displayname = UserModel.currentUser().displayName!;
    bio = UserModel.currentUser().bio!;
    tags = UserModel.currentUser().tags!;
    FirebaseMessaging.instance.requestPermission();
    notifs = (UserModel.currentUser().notifparam!).cast<String, bool>();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/3,
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
                ),
              ),

              Positioned(
                top: 70,
                left: 15,
                child: GestureDetector(
                  onTapUp: (t) {
                    Navigator.pop(context);
                  },
                  child: GlassContainer(
                    height: 38,
                    width: 43,
                    blur: 8,
                    shadowStrength: 5,
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.arrow_left,
                        size: 22,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 70,
                right: 15,
                child: GestureDetector(
                  onTapUp: (t) {
                    Navigator.pop(context);
                  },
                  child: GestureDetector(
                    onTapUp: (t) async {

                    },
                    child: GlassContainer(
                      height: 38,
                      width: 140,
                      color: Colors.white.withOpacity(0.8),
                      blur: 10,
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(!done)
                            Text(
                              "Enregistrer",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 7*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), color: Colors.black.withOpacity(0.7)),
                            ),
                          if(done)
                            CupertinoActivityIndicator(color: Colors.black.withOpacity(0.7), radius: 4*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),)
                        ],
                      ),
                    ),
                  )
                ),
              ),


          Positioned(
            top: MediaQuery.of(context).size.height * 0.3 - 50,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.7 + 50,
              width: double.infinity,
              decoration: BoxDecoration(
              color: const Color(0xFFF3F5F8),
              borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28.0),
              topRight: Radius.circular(28.0),
              ),
            ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(

                                children: [
                                  const Text(
                                    "Parametres géneraux  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 24),
                                  ),
                                  Image.asset("assets/images/emoji_settings.png", height: 22,)
                                ],
                              ),
                            ),
                          )
                        ),
                        const SizedBox(height: 50,),
                        GestureDetector(
                          onTapUp: (t){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotifSettings(),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Parametres de notifications ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black.withOpacity(0.6)),
                                ),
                                Icon(Icons.arrow_forward_ios, color: Colors.black.withOpacity(0.6), size: 16,)
                              ],
                            ),
                          )
                        ),
                        const SizedBox(height: 15,),
                        Container(color: Colors.black.withOpacity(0.08), width: double.infinity, height: 1.5,),
                        const SizedBox(height: 15,),
                        GestureDetector(
                          onTapUp: (t){
                            showCupertinoDialog<void>(
                                context: context,
                                builder: (BuildContext context) => CupertinoAlertDialog(
                                title: const Text('Se déconnecter'),
                                content: Text('Es-tu vraiment sûr de vouloir te déconnecter ?'),
                                actions: <CupertinoDialogAction>[
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Non'),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => UsernamePage()),
                                      );
                                      Haptics.vibrate(HapticsType.success);
                                    },
                                    child: const Text('Oui'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Se déconnecter",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Container(color: Colors.black.withOpacity(0.08), width: double.infinity, height: 1.5,),
                        const SizedBox(height: 15,),
                        GestureDetector(
                          onTapUp: (t){

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Supprimer ton compte",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16, color: Colors.red.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
      ),
      )
      )
          ]
      )
    )
    );
  }
}
