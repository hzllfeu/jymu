import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/Models/TrainingModel.dart';
import 'package:jymu/screens/ProfilPageBis.dart';
import 'package:jymu/screens/home/LoadingProfileList.dart';
import 'package:jymu/screens/home/TrainingCard.dart';
import 'package:jymu/screens/home/components/TrainingPage.dart';
import 'package:jymu/screens/home/components/hero_dialog_route.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;


import '../../Models/CachedData.dart';
import '../../Models/NotificationService.dart';
import '../../Models/UserModel.dart';
import '../InputPage.dart';

class NotifListComp extends StatefulWidget {
  final NotificationModel notif;
  final int index;

  const NotifListComp({
    super.key, required this.notif, required this.index,
  });

  @override
  _NotifListCompState createState() => _NotifListCompState();
}

class _NotifListCompState extends State<NotifListComp> {

  Future<void>? data;
  String userID = "";
  String trnID = "";
  String comment = "";
  Timestamp? date;
  String pp = "";
  TrainingModel trn = TrainingModel();


  @override
  void initState() {
    super.initState();
    data = getExtData();
  }

  late File fistImage;

  Future<void> getExtData() async {


    if(widget.notif.ext){
      if(CachedData().links.containsKey(widget.notif.extid)){
        pp = CachedData().links[widget.notif.extid]!;
      } else {
        pp = await getProfileImageUrl(widget.notif.extid);
        CachedData().links[widget.notif.extid] = pp;
      }
    }
    if(widget.notif.actionid != ""){
      if(CachedData().images.containsKey(widget.notif.actionid)){
        fistImage = CachedData().images[widget.notif.actionid]!;
      } else {
        fistImage = (await getImage(widget.notif.actionid))!;
        CachedData().images[widget.notif.actionid] = fistImage;
      }
    }
    if(CachedData().trainings.containsKey(widget.notif.postid)){
      trn = CachedData().trainings[widget.notif.postid]!;
    } else {
      await trn.fetchExternalData(widget.notif.postid);
      CachedData().trainings[widget.notif.postid] = trn;
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingProfileList();
        } else if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        } else if (snapshot.hasData) {
          return const LoadingProfileList();
        } else {
          return GestureDetector(
            onTapUp: (t) async {
              if(widget.notif.type == "abo"){
                if(widget.notif.extid != FirebaseAuth.instance.currentUser?.uid) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilPageBis(id: widget.notif.extid),
                    ),
                  );
                }
              }
            },
            child: Hero(
              tag: "${widget.index.toString()}${widget.notif.postid}",
              transitionOnUserGestures: true,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(widget.notif.type == "abo")
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTapUp: (t){
                                if(widget.notif.extid != FirebaseAuth.instance.currentUser?.uid){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilPageBis(id: widget.notif.extid),
                                    ),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                radius: 24.0,
                                backgroundImage: CachedNetworkImageProvider(pp),
                              ),
                            ),

                            const SizedBox(width: 15),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${widget.notif.title} ",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 5 * MediaQuery.of(context).size.width * 0.0075,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${widget.notif.message} ",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 5 * MediaQuery.of(context).size.width * 0.0075,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "  ${timeago.format(widget.notif.timestamp.toDate(), locale: 'fr')}",
                                      style: TextStyle(
                                        color: CupertinoColors.systemGrey,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 5 * MediaQuery.of(context).size.width * 0.006,
                                      ),
                                    ),
                                  ],
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if(widget.notif.type == "abo")
                      Container(
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.deepOrange.withOpacity(1),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child:Text(
                            "Voir",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    if(widget.notif.type == "like")
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTapUp: (t){
                                if(widget.notif.extid != FirebaseAuth.instance.currentUser?.uid){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilPageBis(id: widget.notif.extid),
                                    ),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                radius: 24.0,
                                backgroundImage: CachedNetworkImageProvider(pp),
                              ),
                            ),

                            const SizedBox(width: 15),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${widget.notif.title} ",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 5 * MediaQuery.of(context).size.width * 0.0075,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${widget.notif.message} ",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 5 * MediaQuery.of(context).size.width * 0.0075,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "  ${timeago.format(widget.notif.timestamp.toDate(), locale: 'fr')}",
                                      style: TextStyle(
                                        color: CupertinoColors.systemGrey,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 5 * MediaQuery.of(context).size.width * 0.006,
                                      ),
                                    ),
                                  ],
                                ),
                                softWrap: true,  // Pour permettre au texte de passer à la ligne
                              ),
                            ),
                          ],
                        ),
                      ),
                    if(widget.notif.type == "like")
                      GestureDetector(
                        onTapUp: (t){
                          Navigator.push(
                            context,
                            HeroDialogRoute(
                              builder: (context) =>
                                  TrainingPage(trn: trn, type: widget.index.toString(),),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(1),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(image: Image.file(fistImage).image, fit: BoxFit.cover)
                          ),
                        ),
                      ),
                    if(widget.notif.type == "com")
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTapUp: (t){
                                if(widget.notif.extid != FirebaseAuth.instance.currentUser?.uid){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilPageBis(id: widget.notif.extid),
                                    ),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                radius: 24.0,
                                backgroundImage: CachedNetworkImageProvider(pp),
                              ),
                            ),

                            const SizedBox(width: 15),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${widget.notif.title} ",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 5 * MediaQuery.of(context).size.width * 0.0075,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${widget.notif.message} ",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 5 * MediaQuery.of(context).size.width * 0.0075,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "  ${timeago.format(widget.notif.timestamp.toDate(), locale: 'fr')}",
                                      style: TextStyle(
                                        color: CupertinoColors.systemGrey,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 5 * MediaQuery.of(context).size.width * 0.006,
                                      ),
                                    ),
                                  ],
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if(widget.notif.type == "com")
                      GestureDetector(
                        onTapUp: (t){
                          Navigator.push(
                            context,
                            HeroDialogRoute(
                              builder: (context) =>
                                  TrainingPage(trn: trn, type: widget.index.toString(),),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(1),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(image: Image.file(fistImage).image, fit: BoxFit.cover)
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          );
        }
      },
    );
  }
}

Future<String> getProfileImageUrl(String uid) async {
  try {
    final storageRef = FirebaseStorage.instance.ref().child('user_profiles/$uid.jpg');
    final url = await storageRef.getDownloadURL();
    return url;
  } catch (e) {
    print('Erreur lors de la récupération de l\'image de profil : $e');
    return 'https://via.placeholder.com/150';
  }
}

Future<File?> getImage(String imagePath) async {
  try {
    String downloadUrl = await FirebaseStorage.instance.ref().child('images/$imagePath').getDownloadURL();

    var response = await http.get(Uri.parse(downloadUrl));

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    File file = File('$tempPath/${imagePath.split('/').last}');

    await file.writeAsBytes(response.bodyBytes);

    return file;
  } catch (e) {
    print('Erreur lors du téléchargement du fichier: $e');
    return null;
  }
}
