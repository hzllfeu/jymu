import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jymu/screens/home/components/Notification.dart';
import 'package:jymu/screens/home/components/exercice_template.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class RechercheComp extends StatefulWidget {
  const RechercheComp({super.key});

  static String routeName = "/";

  @override
  State<RechercheComp> createState() => _RechercheCompState();
}

class _RechercheCompState extends State<RechercheComp> {

  bool i = true;
  String nom = "Hugo Vincent";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              Row(
                children: [
                  GestureDetector(
                    onTapUp: (t) {
                      Navigator.pop(context);
                    },
                    child: Icon(CupertinoIcons.arrow_left, size: 25, color: Colors.black.withOpacity(0.6),),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              const CupertinoSearchTextField(
                  placeholder: "Chercher un exercice",
                ),

              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 60,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffF14BA9).withOpacity(0.3),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: const DefaultTextStyle(
                              style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w700, fontSize: 28),
                              child: Text("26",),
                            ),
                          )
                      ),
                      const SizedBox(height: 10,),
                      DefaultTextStyle(
                        style: TextStyle(color: Color(0xff37085B).withOpacity(0.7), fontWeight: FontWeight.w500, fontSize: 14),
                        child: Text("Exercices adaptés à",),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(color: Color(0xff37085B).withOpacity(0.7), fontWeight: FontWeight.w500, fontSize: 14),
                        child: Text("votre profil.",),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepOrangeAccent.withOpacity(0.3),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: const DefaultTextStyle(
                              style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w700, fontSize: 28),
                              child: Text("80%",),
                            ),
                          )
                      ),
                      const SizedBox(height: 10,),
                      DefaultTextStyle(
                        style: TextStyle(color: Color(0xff37085B).withOpacity(0.7), fontWeight: FontWeight.w500, fontSize: 14),
                        child: Text("De compatibilité avec",),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(color: Color(0xff37085B).withOpacity(0.7), fontWeight: FontWeight.w500, fontSize: 14),
                        child: Text("votre profil.",),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30,),
              SingleChildScrollView(
                child: Column(
                  children: [
                    ExoTemplate(),
                    ExoTemplate(),
                    ExoTemplate(),
                    ExoTemplate(),
                    ExoTemplate(),
                    ExoTemplate(),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
