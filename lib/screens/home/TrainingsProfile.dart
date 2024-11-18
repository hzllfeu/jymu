import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Models/TrainingModel.dart';
import 'package:jymu/screens/home/LoadingLikes.dart';
import 'package:jymu/screens/home/TrainingLittle.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


import '../../Models/CachedData.dart';
import '../../Models/UserModel.dart';

import 'package:flutter/material.dart';

class TrainingsProfile extends StatefulWidget {
  final UserModel user;

  const TrainingsProfile({super.key, required this.user});

  @override
  _TrainingsProfileState createState() => _TrainingsProfileState();
}

class _TrainingsProfileState extends State<TrainingsProfile> {
  Future<void>? data;
  List<TrainingModel> sortedTrainings = [];
  TrainingModel trn = TrainingModel();

  Future<void> loadData() async {
    List<Map<String, dynamic>> trainings = [];

    for (var training in widget.user.trainings!) {
      Map<String, dynamic> trainingData = {
        "training": training["training"],
        "timestamp": training["timestamp"],
      };
      trainings.add(trainingData);
    }

    trainings.sort((a, b) => b["timestamp"].compareTo(a["timestamp"]));

    for (var training in trainings) {
      Map<String, dynamic> trainingData = {
        "training": training["training"],
        "timestamp": training["timestamp"],
      };
      TrainingModel trn = TrainingModel();
      if(CachedData().trainings.containsKey(training["training"])){
        trn = CachedData().trainings[training["training"]]!;
      } else {
        await trn.fetchExternalData(training["training"]);
        CachedData().trainings[training["training"]] = trn;
      }
      sortedTrainings.add(trn);
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
          return Center(
            child: Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2), child: const CupertinoActivityIndicator(radius: 14,),)
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement du post'));
        } else {
          if(sortedTrainings.isEmpty){
            return Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/emoji_bell.png", height: 28,),
                  SizedBox(height: 15,),
                  DefaultTextStyle(
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 15),
                    child: Text("Abonne toi pour savoir quand ${widget.user.username}"),
                  ),
                  SizedBox(height: 3,),
                  DefaultTextStyle(
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 15),
                    child: Text("postera pour la première fois"),
                  ),
                ],
              )
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(0.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 0.7,
            ),
            itemCount: sortedTrainings.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final training = sortedTrainings[index];
              return TrainingLittle(trn: training, trending: false, type: "profile",);
            },
          );
        }
      },
    );
  }
}