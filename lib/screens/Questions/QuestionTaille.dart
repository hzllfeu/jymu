import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import 'QuestionPoidAc.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class QuestionTaille extends StatefulWidget {

  final int poidobj;
  final int sexe;
  final int obj;

  const QuestionTaille({super.key, required this.sexe, required this.poidobj, required this.obj});

  static String routeName = "/";

  @override
  State<QuestionTaille> createState() => _QuestionTailleState();
}

class _QuestionTailleState extends State<QuestionTaille> {

  int ob = 145;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTapUp: (t) {
                        Navigator.pop(context);
                      },
                      child: const Icon(CupertinoIcons.arrow_left, size: 28,),
                    ),
                    Text(
                      "Etape 8/22",
                      style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    GestureDetector(
                      onTapUp: (t) {
                        Navigator.pop(context);
                      },
                      child: const Icon(CupertinoIcons.arrow_left, size: 28, color: Colors.transparent,),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Image.asset("assets/images/emoji_rocket.png", height: 32,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Quelle est votre taille ?",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30, color: Colors.black.withOpacity(0.8)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 70,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer(
                        height: 120,
                        width: double.infinity,
                        blur: 8,
                        color: Colors.white.withOpacity(0.2),

                        borderRadius: BorderRadius.circular(30),
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
                        child: Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                    height: 70,
                                    width: 200,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.8),
                                          Colors.white60.withOpacity(0.8),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1), // Couleur de l'ombre
                                          spreadRadius: 3, // Rayon de diffusion
                                          blurRadius: 7, // Flou de l'ombre
                                          offset: Offset(0, 3), // Décalage de l'ombre
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Vous faites $ob cm",
                                        style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTapUp: (t) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuestionPoidAc(sexe: widget.sexe, poidobj: widget.poidobj, obj: widget.obj, taille: ob,),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                      height: 70,
                                      width: 120,
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.orange.withOpacity(0.8),
                                            Colors.pinkAccent.withOpacity(0.8),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3), // Couleur de l'ombre
                                            spreadRadius: 3, // Rayon de diffusion
                                            blurRadius: 7, // Flou de l'ombre
                                            offset: Offset(0, 3), // Décalage de l'ombre
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Suivant",
                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GlassContainer(
                        height: 240,
                        width: double.infinity,
                        blur: 8,
                        color: Colors.white.withOpacity(0.2),

                        borderRadius: BorderRadius.circular(30),
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
                        child: Expanded(
                          child: CupertinoPicker(
                              itemExtent: 41,
                              onSelectedItemChanged: (int value) {
                                setState(() {
                                  ob = value + 145;
                                });
                              },
                              scrollController: FixedExtentScrollController(
                                  initialItem: 0
                              ),
                              children: const [
                                Text("145"),
                                Text("146"),
                                Text("147"),
                                Text("148"),
                                Text("149"),
                                Text("150"),
                                Text("151"),
                                Text("152"),
                                Text("153"),
                                Text("154"),
                                Text("155"),
                                Text("156"),
                                Text("157"),
                                Text("158"),
                                Text("159"),
                                Text("160"),
                                Text("161"),
                                Text("162"),
                                Text("163"),
                                Text("164"),
                                Text("165"),
                                Text("166"),
                                Text("167"),
                                Text("168"),
                                Text("169"),
                                Text("170"),
                                Text("171"),
                                Text("172"),
                                Text("173"),
                                Text("174"),
                                Text("175"),
                                Text("176"),
                                Text("177"),
                                Text("178"),
                                Text("179"),
                                Text("180"),
                                Text("181"),
                                Text("182"),
                                Text("183"),
                                Text("184"),
                                Text("185"),
                                Text("186"),
                                Text("187"),
                                Text("188"),
                                Text("189"),
                                Text("190"),
                                Text("191"),
                                Text("192"),
                                Text("193"),
                                Text("194"),
                                Text("195"),
                                Text("196"),
                                Text("197"),
                                Text("198"),
                                Text("199"),
                                Text("200"),
                                Text("201"),
                                Text("202"),
                                Text("203"),
                                Text("204"),
                                Text("205"),
                                Text("206"),
                                Text("207"),
                                Text("208"),
                                Text("209"),
                                Text("210"),
                              ]
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 50,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
