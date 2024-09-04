import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import 'package:jymu/Alexis/ia_init_var_user.dart';
import 'package:jymu/Alexis/ia_q5_objprinc.dart';


class QuestionNiveauMuscu extends StatefulWidget {
  const QuestionNiveauMuscu({super.key});

  static String routeName = "/";

  @override
  State<QuestionNiveauMuscu> createState() => _QuestionNiveauMuscuState();
}

class _QuestionNiveauMuscuState extends State<QuestionNiveauMuscu> {
  final GlobalListManager listManager = GlobalListManager();
  double niveauMuscu = 0.0;

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
                      "Etape 4/8",
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
                      "Quel est votre niveau en musculation ?",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
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
                              "Niveau: ${niveauMuscu.toStringAsFixed(1)}",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CupertinoSlider(
                              value: niveauMuscu,
                              min: 0.0,
                              max: 10.0,
                              divisions: 100,
                              onChanged: (value) {
                                setState(() {
                                  niveauMuscu = value;
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
                            listManager.dynamicList[7] = niveauMuscu;
                          });
                          // Passer à l'étape suivante
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionObjectifPrincipal(),
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
