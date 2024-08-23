import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class ProComp extends StatefulWidget {
  const ProComp({super.key});

  static String routeName = "/";

  @override
  State<ProComp> createState() => _ProCompState();
}

class _ProCompState extends State<ProComp> {

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
          const SizedBox(height: 30,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 45,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
                      child: Text("JymuPro",),
                    ),
                    Image.asset(
                      "assets/images/emoji_goat.png",
                      height: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),

        Container(
          width: double.infinity,
          height: 330,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.amberAccent.withOpacity(0.2), Colors.deepOrangeAccent.withOpacity(0.3)],
            ),
          ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 13),
                  child: Text("pour seulement",),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 110,
                        height: 70,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DefaultTextStyle(
                                  style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w600, fontSize: 32),
                                  child: Text("0.99€",),
                                ),
                                const DefaultTextStyle(
                                  style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 16),
                                  child: Text("/ mois",),
                                ),
                              ],
                            )
                        )
                    )
                  ],
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/emoji_goat.png",
                      height: 28,
                    ),
                    Image.asset(
                      "assets/images/emoji_fire.png",
                      height: 28,
                    ),
                    Image.asset(
                      "assets/images/emoji_rocket.png",
                      height: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    const DefaultTextStyle(
                      style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 18),
                      child: Text("• Met à jour ton "),
                    ),
                    Container(
                        width: 120,
                        height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrangeAccent.withOpacity(0.4),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: const DefaultTextStyle(
                            style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 18),
                            child: Text("entrainement", textAlign: TextAlign.center,),
                          ),
                        )
                    )
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    const DefaultTextStyle(
                      style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 18),
                      child: Text("• Obtiens le "),
                    ),
                    Container(
                        width: 60,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrangeAccent.withOpacity(0.4),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: const DefaultTextStyle(
                            style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 18),
                            child: Text("badge", textAlign: TextAlign.center,),
                          ),
                        )
                    ),
                    const DefaultTextStyle(
                      style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 18),
                      child: Text(" JymPro"),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    const DefaultTextStyle(
                      style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 18),
                      child: Text("• Suis "),
                    ),
                    Container(
                        width: 65,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrangeAccent.withOpacity(0.4),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: const DefaultTextStyle(
                            style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 18),
                            child: Text("toutes", textAlign: TextAlign.center,),
                          ),
                        )
                    ),
                    const DefaultTextStyle(
                      style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 18),
                      child: Text(" tes séances"),
                    ),
                  ],
                ),
              ],
            ),
        ),

          const SizedBox(height: 20,),

          Container(
            width: double.infinity,
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.amberAccent.withOpacity(0.8), Colors.deepOrangeAccent.withOpacity(0.8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrangeAccent.withOpacity(0.8),
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
          const SizedBox(height: 15,),
          DefaultTextStyle(
            style: TextStyle(color: Color(0xff37085B).withOpacity(0.6), fontWeight: FontWeight.w500, fontSize: 12),
            child: Text("En payant vous acceptez nos conditions d'utilisation", textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }
}
