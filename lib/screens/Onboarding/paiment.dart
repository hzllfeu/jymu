import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jymu/RequeteProfile.dart';
import 'package:jymu/screens/home/HomeScreen.dart';

import '../home/components/ProfileComp.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class Paiement extends StatefulWidget {
  const Paiement({super.key});

  static String routeName = "/";

  @override
  State<Paiement> createState() => _PaiementState();
}

class _PaiementState extends State<Paiement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.amberAccent.withOpacity(0.8),
              Colors.deepOrangeAccent.withOpacity(0.8)
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
                        child: Icon(CupertinoIcons.arrow_left, size: 28,),
                      ),
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
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
                        child: Icon(CupertinoIcons.info, size: 26,),
                      ),
                    ),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Text(
                  "Etape du paiement",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 28),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: 550,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.6)],
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultTextStyle(
                            style: TextStyle(color: Color(0xff37085B).withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 15),
                            child: Text("Total", textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orangeAccent.withOpacity(0.5),
                                    spreadRadius: 4,
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: const DefaultTextStyle(
                                  style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 30),
                                  child: Text("6.99€",),
                                ),
                              )
                          )
                        ],
                      ),
                      const SizedBox(height: 7,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultTextStyle(
                            style: TextStyle(color: Color(0xff37085B).withOpacity(0.4), fontWeight: FontWeight.w600, fontSize: 14),
                            child: Text("Pas de code", textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25,),
                      Container(
                        height: 1,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xff37085B).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                      const SizedBox(height: 25,),

                      DefaultTextStyle(
                        style: TextStyle(color: Color(0xff37085B).withOpacity(0.8), fontWeight: FontWeight.w600, fontSize: 16),
                        child: Text("Code de parrainage ou réduction", textAlign: TextAlign.center,),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 60,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
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
                                child: CupertinoTextField(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent
                                  ),
                                  placeholder: "0 0 0 - 0 0 0",
                                  placeholderStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xff37085B).withOpacity(0.4)),
                                  textAlign: TextAlign.center,
                                )
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            width: 120,
                            height: 60,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Color(0xffF14BA9).withOpacity(0.7), Colors.redAccent.withOpacity(0.7)],
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
                              child: DefaultTextStyle(
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                                child: Text("Utiliser", textAlign: TextAlign.center,),
                              ),
                            )
                          ),
                        ],
                      ),

                      const SizedBox(height: 10,),

                      DefaultTextStyle(
                        style: TextStyle(color: Color(0xff37085B).withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 14),
                        child: Text("Si un ami te parraine, l'accès est", textAlign: TextAlign.center,),
                      ),
                      const SizedBox(height: 3,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          DefaultTextStyle(
                            style: TextStyle(color: Color(0xff37085B).withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 14),
                            child: Text("seulement à ", textAlign: TextAlign.center,),
                          ),
                          const SizedBox(width: 5,),
                          Container(
                              width: 40,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orangeAccent.withOpacity(0.5),
                                    spreadRadius: 4,
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: DefaultTextStyle(
                                  style: TextStyle(color: Color(0xff37085B).withOpacity(0.8), fontWeight: FontWeight.w600, fontSize: 14),
                                  child: Text("1.99€",),
                                ),
                              )
                          ),
                          const SizedBox(width: 5,),
                          DefaultTextStyle(
                            style: TextStyle(color: Color(0xff37085B).withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 14),
                            child: Text(" Si tu utilises un", textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          DefaultTextStyle(
                            style: TextStyle(color: Color(0xff37085B).withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 14),
                            child: Text("code d'influenceur l'accès est à ", textAlign: TextAlign.center,),
                          ),
                          const SizedBox(width: 5,),
                          Container(
                              width: 45,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orangeAccent.withOpacity(0.5),
                                    spreadRadius: 4,
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: DefaultTextStyle(
                                  style: TextStyle(color: Color(0xff37085B).withOpacity(0.8), fontWeight: FontWeight.w600, fontSize: 14),
                                  child: Text("2.99€",),
                                ),
                              )
                          ),
                        ],
                      ),

                      const SizedBox(height: 25,),
                      Container(
                        height: 1,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xff37085B).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                      const SizedBox(height: 25,),

                      Row(
                        children: [
                          Image.asset("assets/images/emoji_money.png", height: 18,),
                          const SizedBox(width: 5,),
                          DefaultTextStyle(
                            style: TextStyle(color: Color(0xff37085B).withOpacity(0.8), fontWeight: FontWeight.w600, fontSize: 16),
                            child: Text("Adresse de facturation", textAlign: TextAlign.center,),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
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
                              child: DefaultTextStyle(
                                style: TextStyle(color: Color(0xff37085B).withOpacity(0.7), fontWeight: FontWeight.w600, fontSize: 14),
                                child: Text("louis.mouchon@live.com", textAlign: TextAlign.center,),
                              ),
                            ),
                          ),
                          Image.asset("assets/images/apple-pay.png", height: 50,)
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          const SizedBox(width: 5,),
                          Icon(CupertinoIcons.person, color: Color(0xff37085B), size: 16,),
                          const SizedBox(width: 10,),
                          DefaultTextStyle(
                            style: TextStyle(color: Color(0xff37085B).withOpacity(0.7), fontWeight: FontWeight.w600, fontSize: 14),
                            child: Text("Louis Mouchon, 20 ans", textAlign: TextAlign.center,),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                GestureDetector(
                  onTapUp: (tap) {
                    FetchProfile(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xffF14BA9).withOpacity(0.8), Colors.redAccent.withOpacity(0.8)],
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
                            child: Text("Payer",),
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
