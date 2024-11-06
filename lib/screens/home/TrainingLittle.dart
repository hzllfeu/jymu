import 'dart:io';

import 'package:animated_page_transition/animated_page_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Models/TrainingModel.dart';
import 'package:jymu/screens/home/TrainingCard.dart';
import 'package:jymu/screens/home/components/TrainingPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


import '../../Models/CachedData.dart';

class TrainingLittle extends StatefulWidget {
  final TrainingModel trn;

  const TrainingLittle({super.key, required this.trn});

  @override
  _TrainingLittleState createState() => _TrainingLittleState();
}

class _TrainingLittleState extends State<TrainingLittle> with TickerProviderStateMixin {
  Future<void>? data;
  File? fistImage;

  Future<void> loadData() async {
    if(CachedData().images.containsKey(widget.trn.firstImage!)){
      fistImage = CachedData().images[widget.trn.firstImage!]!;
    } else {
      fistImage = (await getImage(widget.trn.firstImage!))!;
      CachedData().images[widget.trn.firstImage!] = fistImage!;
    }
  }

  @override
  void initState() {
    super.initState();
    data = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 120,
            ),
            child: Container(
              width: double.infinity,
              height: 150,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FadeShimmer(
                    height: 30,
                    width: 80,
                    radius: 6,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 120,
            ),
            child: Container(
              width: double.infinity,
              height: 150,
              padding: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.nosign, color: Colors.black.withOpacity(0.6), size: 22,),
                    const SizedBox(height: 10,),
                    Text("Post indisponnible", style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.center,)
                  ],
                ),
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTapUp: (t){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainingPage(trn: widget.trn, image: fistImage!,),
                ),
              );
            },
            child: Hero(tag: widget.trn.id!,
              transitionOnUserGestures: true,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 120,
                ),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(5.0),
                      image: DecorationImage(
                          image: Image.file(fistImage!).image,
                          fit: BoxFit.cover
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width*0.2
                        ),
                        child: GlassContainer(
                          height: 30,
                          color: Colors.black.withOpacity(0.5),
                          blur: 10,
                          borderRadius: BorderRadius.circular(18),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    formatDate(widget.trn.date!.toDate()),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
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
}