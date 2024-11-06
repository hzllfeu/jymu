import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/Models/TrainingModel.dart';
import 'package:jymu/PostManager.dart';
import 'package:jymu/screens/home/LoadingTraining.dart';
import 'package:jymu/screens/home/components/TagList.dart';

import '../TrainingCard.dart';

class TrainingPage extends StatefulWidget {
  late TrainingModel trn;
  final File image;

  TrainingPage({super.key, required this.trn, required this.image});

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {

  @override
  Widget build(BuildContext context) {
    return Hero(tag: widget.trn.id!,
    transitionOnUserGestures: true,
    child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTapUp: (t) {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        CupertinoIcons.arrow_left,
                        size: 22,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    Text(widget.trn.username??"", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: Colors.black.withOpacity(0.7)),),
                    Icon(
                      CupertinoIcons.arrow_left,
                      size: 22,
                      color: CupertinoColors.transparent,
                    ),
                  ],
                ),
              ),
              TrainingCard(trn: widget.trn, coverimage: widget.image, coverbool: true,),
            ],
          ),
        )
    )
    );
  }
}
