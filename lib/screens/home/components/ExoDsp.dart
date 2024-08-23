import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/RequeteProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class ExoDsp extends StatefulWidget {
  const ExoDsp({super.key});

  static String routeName = "/";

  @override
  State<ExoDsp> createState() => _ExoDspState();
}

class _ExoDspState extends State<ExoDsp> {

  bool i = true;
  String nom = "Hugo Vincent";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
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
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               DefaultTextStyle(
                style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w700, fontSize: 22),
                child: Text("Tirage poulie",),
              ),
              const SizedBox(width: 15,),
              Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Center(
                  child: DefaultTextStyle(
                    style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w700, fontSize: 18),
                    child: Text("Triceps",),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 30,),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(radius: 12,),
                  SizedBox(height: 15,),
                  DefaultTextStyle(
                    style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w500, fontSize: 14),
                    child: Text("Chargement de la vidéo",),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,),
          GlassContainer(
              height: 280,
              width: double.infinity,
              blur: 8,
              color: Colors.white.withOpacity(0.2),

              borderRadius: BorderRadius.circular(30),
              shadowColor: Colors.black,
              shadowStrength: 1.1,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.amberAccent.withOpacity(1),
                  Colors.redAccent.withOpacity(1),
                ],
              ),
              child:Center(
              )
          )
        ],
      ),
    );
  }
}
