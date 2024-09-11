import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import 'package:jymu/Alexis/ia_q3_poids.dart';
import 'package:jymu/Alexis/ia_init_var_user.dart';
import 'package:jymu/screens/init_screen.dart';
const Color inActiveIconColor = Color(0xFFFFC0CB);

class QuestionTaillee extends StatefulWidget {
  const QuestionTaillee({super.key});

  static String routeName = "/";

  @override
  State<QuestionTaillee> createState() => _QuestionTailleState();
}

class _QuestionTailleState extends State<QuestionTaillee> {
  int ob = 175;
  final GlobalListManager listManager = GlobalListManager();
  double valeur_progbarre = 200;

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
                      child: Container(
                        height: 38,
                        width: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                            child: Image.asset('assets/images/emoji_leftarrow.png', height: 24,)
                        ),
                      ),
                    ),
                    // Barre de progression personnalisée
                    Container(
                      height: 28,
                      width: valeur_progbarre,  // Ajuste cette largeur comme tu le souhaites
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.grey.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            // Cette partie représente la progression actuelle (50% pour l'exemple)
                            width: 2*valeur_progbarre/8, // Ajuste cette valeur pour la progression
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTapUp: (t) {
                        _showExitConfirmationDialog(context);
                      },
                      child: Container(
                        height: 38,
                        width: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset('assets/images/emoji_cross.png', height: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25,vertical: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200], // Couleur de fond du cercle
                      ),
                      child: Center(
                        child: Image.asset('assets/images/emoji_panda.png', height: 20),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Continuons ainsi ...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80,),
              Column(
                children: [

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Quelle est ta taille actuel ?",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30, color: Colors.black.withOpacity(0.8)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 65,),
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
                                        "Tu mesures $ob cms",
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
                                  initialItem: 30
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
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour afficher le dialogue de confirmation lors de la sortie
  void _showExitConfirmationDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Confirmation"),
          content: Text("Êtes-vous sûr de vouloir abandonner le questionnaire ? Vos données ne seront pas sauvegardées."),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text("Oui"),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InitScreen(initialIndex: 1), // Rediriger vers la page IaGene
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
