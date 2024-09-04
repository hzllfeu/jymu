import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Alexis/ia_gene.dart';

import 'package:jymu/Alexis/ia_init_var_user.dart';
import 'package:jymu/Alexis/ia_q8_intensi.dart';

class QuestionFocusCorps extends StatefulWidget {
  const QuestionFocusCorps({super.key});

  static String routeName = "/";

  @override
  State<QuestionFocusCorps> createState() => _QuestionFocusCorpsState();
}

class _QuestionFocusCorpsState extends State<QuestionFocusCorps> {
  final GlobalListManager listManager = GlobalListManager();
  double focusCorps = 5.0;

  String _getFocusDescription(double focusValue) {
    if (focusValue <= 3.0) {
      return "Bas du corps";
    } else if (focusValue >= 7.0) {
      return "Haut du corps";
    } else {
      return "Équilibré";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTapUp: (t) {
                        Navigator.pop(context);
                      },
                      child: const Icon(CupertinoIcons.arrow_left, size: 28),
                    ),
                    Text(
                      "Etape 7/8",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Icon(
                      CupertinoIcons.arrow_left,
                      size: 28,
                      color: Colors.transparent,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Quelle partie du corps voulez-vous travailler ?",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "0 : Bas du corps | 10 : Haut du corps",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Focus: ${_getFocusDescription(focusCorps)}",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CupertinoSlider(
                              value: focusCorps,
                              min: 0.0,
                              max: 10.0,
                              divisions: 100,
                              onChanged: (value) {
                                setState(() {
                                  focusCorps = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer(
                      height: 70,
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
                          Colors.orange.withOpacity(0.8),
                          Colors.pinkAccent.withOpacity(0.8),
                        ],
                      ),
                      child: GestureDetector(
                        onTapUp: (t) {
                          // Modifier la valeur dans la liste dynamique
                          setState(() {
                            listManager.dynamicList[8] = focusCorps;
                          });
                          // Passer à l'étape suivante
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionIntensite(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            "Suivant",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
              // Affichage de la liste dynamique en bas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  listManager.dynamicList.toString(),
                  style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
