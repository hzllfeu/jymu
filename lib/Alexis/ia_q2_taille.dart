import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import 'package:jymu/Alexis/ia_q3_poids.dart';
import 'package:jymu/Alexis/ia_init_var_user.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class QuestionTaillee extends StatefulWidget {
  const QuestionTaillee({super.key});

  static String routeName = "/";

  @override
  State<QuestionTaillee> createState() => _QuestionTailleState();
}

class _QuestionTailleState extends State<QuestionTaillee> {
  int ob = 145;
  final GlobalListManager listManager = GlobalListManager();

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
                                  // Mettre à jour la deuxième variable dans la liste avec la taille sélectionnée
                                  setState(() {
                                    listManager.dynamicList[3] = ob.toDouble();
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuestionPoidAcc(),
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
                              children: List.generate(66, (index) {
                                return Text((145 + index).toString());
                              })
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 50,),
                ],
              ),
              // Affichage de la liste dynamique comme texte
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  listManager.dynamicList.toString(), // Affiche la liste dynamique
                  style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w500, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
