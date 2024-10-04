import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/Models/TrainingModel.dart';
import 'package:jymu/screens/home/LoadingProfileList.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../Models/CachedData.dart';
import '../../Models/UserModel.dart';
import '../InputPage.dart';
import 'ProfilPage.dart';

class CommentListComp extends StatefulWidget {
  final String id;
  final List<dynamic> comment;

  const CommentListComp({
    super.key,
    required this.id, required this.comment,
  });

  @override
  _CommentListCompState createState() => _CommentListCompState();
}

class _CommentListCompState extends State<CommentListComp> {

  Future<void>? data;
  String userID = "";
  String trnID = "";
  String comment = "";
  Timestamp? date;
  UserModel targetUser = UserModel();
  String pp = "";
  TrainingModel training = TrainingModel();

  @override
  void initState() {
    super.initState();
    data = getCommentData();
  }


  Future<void> getCommentData() async {

    userID = widget.comment[2];
    trnID = widget.comment[3];
    comment = widget.comment[0];
    date = widget.comment[1];


    if (CachedData().trainings.containsKey(trnID)) {
      training = CachedData().trainings[trnID]!;
    } else {
      await training.fetchExternalData(trnID);
      CachedData().trainings[trnID] = training;
    }

    if(CachedData().users.containsKey(userID)){
      targetUser = CachedData().users[userID]!;
    } else {
      await targetUser.fetchExternalData(userID);
      CachedData().users[userID] = targetUser;
    }

    if(CachedData().links.containsKey(targetUser.id!)){
      pp = CachedData().links[targetUser.id!]!;
    } else {
      pp = await getProfileImageUrl(targetUser.id!);
      CachedData().links[targetUser.id!] = pp;
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
          return Container(
            width: double.infinity,
            // Retirer la hauteur fixe pour permettre l'adaptation de la hauteur du container
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alignement en haut pour s'adapter à plusieurs lignes
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: CachedNetworkImageProvider(pp),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Alignement du texte à gauche
                      children: [
                        Row(
                          children: [
                            Text(
                              targetUser.displayName!,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                                fontSize: 5 * MediaQuery.of(context).size.width * 0.007,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                                timeago.format(date!.toDate(), locale: 'fr'),
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 5 * MediaQuery.of(context).size.width * 0.005,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            comment,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                              fontSize: 5 * MediaQuery.of(context).size.width * 0.007,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTapUp: (t) {
                    _showActionSheet(context);
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: CupertinoColors.systemGrey,
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Options'),
        actions: <CupertinoActionSheetAction>[
          if(UserModel.currentUser().id != userID)
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputPage(text: "Raison du signalement", limit: 300),
                  ),
                );

                if (result != null) {
                  await training.reportComment(result.toString().trim(), widget.id, comment);
                  Haptics.vibrate(HapticsType.light);
                }
              },
              child: const Text('Signaler'),
            ),
          if(UserModel.currentUser().id == userID)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                showCupertinoDialog<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Supprimer'),
                    content: Text('Es-tu vraiment sûr de vouloir supprimer ton commentaire ?'),
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
                          Navigator.pop(context);
                          training.deleteComment(widget.id);
                          Haptics.vibrate(HapticsType.success);
                          setState(() {

                          });
                        },
                        child: const Text('Oui'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Supprimer'),
            ),

        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Annuler'),
        ),
      ),
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
