import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Nizam/exemple.dart';
import 'package:jymu/screens/home/components/NotificationPage.dart';
import 'package:jymu/screens/home/components/NutritionHome.dart';
import 'package:jymu/screens/home/components/ParrainComp.dart';
import 'package:jymu/screens/home/components/ProfileComp.dart';
import 'package:jymu/screens/home/components/banner_exercices.dart';
import 'package:jymu/Alexis/ia_gene.dart';
import 'package:jymu/screens/home/components/exercice_template.dart';
import 'package:jymu/screens/home/components/home_banner.dart';
import 'package:jymu/screens/home/components/home_header.dart';
import 'package:jymu/screens/home/components/nutrition_home.dart';
import 'package:jymu/screens/home/components/rapport_comp.dart';
import 'package:jymu/screens/home/components/training_home.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

import 'components/ProBanner.dart';
import 'components/ProComp.dart';
import 'components/RechercheComp.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.data});

  List<dynamic>? data;

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
        backgroundColor: Color(0xFFF3F5F8),
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
                child: ProBanner(),
              ),

              SizedBox(
                height: 530,
                width: double.infinity,
                child: Swiper(
                  itemCount: 2,
                  containerHeight: 540,
                  containerWidth: double.infinity,
                  itemHeight: 510,
                  itemWidth: double.infinity,
                  itemBuilder: (context, index){
                    if(index == 0){
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          widget.data?[0].toString() ?? 'null',
                          style: TextStyle(fontSize: 35),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          widget.data?[1].toString() ?? 'null',
                          style: TextStyle(fontSize: 35),
                        ),
                      );
                    }
                  },
                  loop: false,

                ),
              ),


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
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffF14BA9).withOpacity(0.2),
                      spreadRadius: 12,
                      blurRadius: 50,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: GlassContainer(
                  height: 110,
                  width: double.infinity,
                  blur: 4,
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(40),
                  shadowColor: Colors.black,
                  shadowStrength: 1.5,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.amberAccent.withOpacity(1),
                      Colors.redAccent.withOpacity(1),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.2)],
                            ),
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
                            borderRadius: BorderRadius.circular(35),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.2)],
                            ),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RechercheComp()),
                          );
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.2)],
                            ),
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
                  //--code to remove border
                ),

              )
            ],
          ),
        )
    );
  }
}
