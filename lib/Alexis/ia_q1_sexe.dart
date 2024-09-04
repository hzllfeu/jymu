import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';


import 'package:jymu/Alexis/ia_init_var_user.dart';
import 'package:jymu/Alexis/ia_q2_taille.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class QuestionSexee extends StatefulWidget {
  const QuestionSexee({super.key});

  static String routeName = "/";

  @override
  State<QuestionSexee> createState() => _QuestionSexeeState();
}

class _QuestionSexeeState extends State<QuestionSexee> {
  // Initialisation du gestionnaire de liste globale
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
                      "Etape 1/8",
                      style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const Icon(CupertinoIcons.arrow_left, size: 28, color: Colors.transparent,),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Vous êtes un/une: ",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30, color: Colors.black.withOpacity(0.8)),
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Affichage de la liste dynamique comme texte
                      Text(
                        listManager.dynamicList.toString(), // Affiche la liste dynamique
                        style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w500, fontSize: 10),
                      ),
                      const SizedBox(height: 5,),
                      Container(
                        height: 20,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.redAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4), // Couleur de l'ombre
                              spreadRadius: 3, // Rayon de diffusion
                              blurRadius: 7, // Flou de l'ombre
                              offset: Offset(0, 3), // Décalage de l'ombre
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer(
                        height: 250,
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 25),
                                    child: Text(
                                      "Choisissez une des deux réponses",
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black54.withOpacity(0.4)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  GestureDetector(
                                    onTapUp: (t) {
                                      // Modifier la première variable de la liste pour Homme
                                      setState(() {
                                        listManager.dynamicList[0] = 1.0; // Utilisez 1.0 pour un homme
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuestionTaillee(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Container(
                                        height: 70,
                                        width: 350,
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.green.withOpacity(0.8),
                                              Colors.blue.withOpacity(0.5),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                                              spreadRadius: 3, // Rayon de diffusion
                                              blurRadius: 7, // Flou de l'ombre
                                              offset: Offset(0, 3), // Décalage de l'ombre
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Homme",
                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(width: 20,),
                                            Image.asset("assets/images/emoji_men.png", height: 26,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTapUp: (t) {
                                      // Modifier la première variable de la liste pour Femme
                                      setState(() {
                                        listManager.dynamicList[0] = 0.0; // Utilisez 0.0 pour une femme
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuestionTaillee(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Container(
                                        height: 70,
                                        width: 350,
                                        padding: EdgeInsets.symmetric(horizontal: 20),
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
                                              color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                                              spreadRadius: 3, // Rayon de diffusion
                                              blurRadius: 7, // Flou de l'ombre
                                              offset: Offset(0, 3), // Décalage de l'ombre
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Femme",
                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(width: 20,),
                                            Image.asset("assets/images/emoji_women.png", height: 26,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 80,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
