import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jymu/Nizam/exemple.dart';
import 'package:jymu/screens/home/components/NotificationPage.dart';
import 'package:jymu/screens/home/components/ParrainComp.dart';
import 'package:jymu/screens/home/components/ProfileComp.dart';
import 'package:jymu/screens/home/components/banner_exercices.dart';
import 'package:jymu/Alexis/exemple.dart';
import 'package:jymu/screens/home/components/exercice_template.dart';
import 'package:jymu/screens/home/components/home_banner.dart';
import 'package:jymu/screens/home/components/home_header.dart';
import 'package:jymu/screens/home/components/nutrition_home.dart';
import 'package:jymu/screens/home/components/rapport_comp.dart';
import 'package:jymu/screens/home/components/training_home.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

import 'components/RechercheComp.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = "/";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool i = true;

  @override
  Widget build(BuildContext context) {

    double initialWidth = 185;
    double initialHeight = 60.0;
    double bounceWidth = i ? 185.0 : 185.0;
    double bounceHeight = 65.0;

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                        GestureDetector(
                          onTapUp: (t) {
                            showCupertinoModalPopup(
                                context: context,
                                barrierColor: Colors.black.withOpacity(0.4), // Définissez la couleur de la barrière sur transparent
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
                                              height: 670,
                                              child: ProfileComp(),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                            );
                          },
                          child: Icon(CupertinoIcons.person_fill, size: 26, color: Color(0xff37085B),),
                        ),
                    Text(
                      "Jymu",
                      style: TextStyle(color:  Colors.transparent, fontWeight: FontWeight.w900, fontSize: 24),
                    ),
                        GestureDetector(
                          onTapUp: (t) {
                            showCupertinoModalPopup(
                                context: context,
                                barrierColor: Colors.black.withOpacity(0.4), // Définissez la couleur de la barrière sur transparent
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
                                              height: 670,
                                              child: NotificationPage(),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                            );
                          },
                          child: Icon(CupertinoIcons.bell_fill, size: 26, color: Color(0xff37085B),),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const BanniereHome(),
              const SizedBox(height: 30,),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            i = false;
                          });
                          Future.delayed(Duration(milliseconds: 100), () {
                            setState(() {
                              i = true;
                            });
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          width: i ? bounceWidth : initialWidth,
                          height: i ? bounceHeight : initialHeight,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: i ? Color(0xffF14BA9) : Colors.deepOrange.withOpacity(0.4),
                            boxShadow: i
                                ? [
                              BoxShadow(
                                color: Color(0xffF14BA9).withOpacity(0.5),
                                spreadRadius: 6,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Entrainement",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Image.asset(
                                "assets/images/emoji_muscle.png",
                                height: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            i = true;
                          });
                          Future.delayed(Duration(milliseconds: 100), () {
                            setState(() {
                              i = false;
                            });
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          width: i ? initialWidth : bounceWidth,
                          height: i ? initialHeight : bounceHeight,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: i ? Colors.deepOrange.withOpacity(0.4) : Color(0xffF14BA9),
                            boxShadow: i
                                ? null
                                : [
                              BoxShadow(
                                color: Color(0xffF14BA9).withOpacity(0.5),
                                spreadRadius: 6,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Nutrition",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Image.asset(
                                "assets/images/emoji_carrot.png",
                                height: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              TrainingComp(),
              const SizedBox(height: 10,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "(Reste appuyer pour generer un nouvel entrainement)",
                    style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.w500, fontSize: 10),
                  )
                ],
              ),
              Container(
                width: 350,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffF14BA9).withOpacity(0.2),
                      spreadRadius: 12,
                      blurRadius: 50,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTapUp: (t) {
                        showCupertinoModalPopup(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.4), // Définissez la couleur de la barrière sur transparent
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
                                          child: ParrainComp(),
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
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrange.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 25,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset("assets/images/emoji_hands.png", height: 30,)
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      onTapUp: (t) {
                        showCupertinoModalPopup(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.4), // Définissez la couleur de la barrière sur transparent
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
                                          height: 400,
                                          child: RapportComp(),
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
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrange.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 25,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset("assets/images/emoji_pencil.png", height: 30,),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      onTapUp: (t) {
                        showCupertinoModalPopup(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.4), // Définissez la couleur de la barrière sur transparent
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
                                          height: 750,
                                          child: RechercheComp(),
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
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrange.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 25,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset("assets/images/emoji_loupe.png", height: 30,),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}
