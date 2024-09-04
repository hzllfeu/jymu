import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Alexis/ia_gene.dart';

import 'package:jymu/Alexis/ia_init_var_user.dart';
import 'package:jymu/Alexis/page_chargement.dart';

class QuestionIntensite extends StatefulWidget {
  const QuestionIntensite({super.key});

  static String routeName = "/";

  @override
  State<QuestionIntensite> createState() => _QuestionIntensiteState();
}

class _QuestionIntensiteState extends State<QuestionIntensite> {
  final GlobalListManager listManager = GlobalListManager();
  double intensite = 5.0;

  String _getIntensityDescription(double intensityValue) {
    if (intensityValue <= 3.0) {
      return "Très faible";
    } else if (intensityValue <= 7.0) {
      return "Modérée";
    } else {
      return "Intense";
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
                      "Etape 6/8",
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
                      "Quelle est l'intensité souhaitée ?",
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
                    "0 : Très faible | 10 : Très intense",
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
                          Colors.deepPurpleAccent.withOpacity(1),
                          Colors.redAccent.withOpacity(1),
                        ],
                      ),
                      child: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Intensité: ${_getIntensityDescription(intensite)}",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CupertinoSlider(
                              value: intensite,
                              min: 0.0,
                              max: 10.0,
                              divisions: 100,
                              onChanged: (value) {
                                setState(() {
                                  intensite = value;
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
                          setState(() {
                            // Modifier la valeur dans la liste dynamique
                            listManager.dynamicList[6] = intensite;

                            // Calculer la nouvelle valeur pour la colonne 6
                            if (listManager.dynamicList.length >= 8) {
                              double newValueForCol6 = listManager.dynamicList[4]/((listManager.dynamicList[3]/100)*(listManager.dynamicList[3]/100));
                              listManager.dynamicList[5] = newValueForCol6; // Colonne 6
                            }
                          });
                          // Passer à l'étape suivante
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoadingPage(),
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
