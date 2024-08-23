import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'ProComp.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class RapportComp extends StatefulWidget {
  const RapportComp({super.key});

  static String routeName = "/";

  @override
  State<RapportComp> createState() => _RapportCompState();
}

class _RapportCompState extends State<RapportComp> {

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
          const SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DefaultTextStyle(
                style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w700, fontSize: 27),
                child: Text("Nouveau rapport",),
              ),
              const SizedBox(width: 10,),
              Image.asset("assets/images/emoji_pencil.png", height: 28,),
            ],
          ),
          const SizedBox(height: 55,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const DefaultTextStyle(
                style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 20),
                child: Text("Tu vas répondre a un "),
              ),
              Container(
                width: 140,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffF14BA9).withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Center(
                  child: const DefaultTextStyle(
                    style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 20),
                    child: Text("questionnaire",),
                  ),
                )
              )
            ],
          ),
          const SizedBox(height: 5,),
          const DefaultTextStyle(
            style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 20),
            child: Text("qui va évaluer tes progrès afin de", textAlign: TextAlign.center,),
          ),
          const SizedBox(height: 5,),
          const DefaultTextStyle(
            style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 20),
            child: Text("modifieret ameliorer ton entrainement."),
          ),
          const SizedBox(height: 35,),
          DefaultTextStyle(
            style: TextStyle(color: Color(0xff37085B).withOpacity(0.6), fontWeight: FontWeight.w500, fontSize: 12),
            child: Text("Dernier rapport il y a 4 jours.", textAlign: TextAlign.center,),
          ),
          const SizedBox(height: 15,),

      GestureDetector(
        onTapUp: (t) {
          showCupertinoModalPopup(
              context: context,
              barrierColor: Colors.black.withOpacity(0.4),
              builder: (BuildContext build) {
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300),
                  tween: Tween<double>(begin: 0.0, end: 4.0),
                  curve: Curves.linear,
                  builder: (context, value, _) {
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 1000),
                      opacity: 1.0,
                      curve: Curves.linear,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: value, sigmaY: value),
                        child: CupertinoPopupSurface(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 630,
                            child: ProComp(),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
          );
        },
          child: Container(
            width: double.infinity,
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xffF14BA9), Colors.redAccent],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffF14BA9).withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24),
                child: Center(
                  child: DefaultTextStyle(
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24),
                    child: Text("Faire un nouveau rapport",),
                  ),
                )
            ),
          ),
      ),
        ],
      ),
    );
  }
}
