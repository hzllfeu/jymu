import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Alexis/ia_init_var_user.dart';
import 'package:jymu/Alexis/page_chargement.dart';

import '../screens/init_screen.dart';

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
      return "Faible";
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
            mainAxisAlignment: MainAxisAlignment.start,
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
                          child: Image.asset('assets/images/emoji_leftarrow.png', height: 24),
                        ),
                      ),
                    ),
                    // Barre de progression personnalisée
                    Container(
                      height: 28,
                      width: 200,
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
                            width: 195, // Largeur de la barre de progression colorée
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: Center(
                        child: Image.asset('assets/images/emoji_panda.png', height: 20),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "C'est la dernière...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 122),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Quelle intensité souhaites tu ?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 143),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer(
                      height: 200,
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
                          Colors.orange,
                          Colors.pinkAccent,
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${intensite.toStringAsFixed(1)}",
                            style: TextStyle(
                              color: Colors.black87,
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
                            thumbColor: Colors.orange,
                            activeColor: Colors.orange,
                          ),
                          SizedBox(height: 10),
                          Text(
                            _getIntensityDescription(intensite),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.orangeAccent.withOpacity(1),
                            Colors.pinkAccent.withOpacity(1),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            listManager.dynamicList[6] = intensite;
                          });
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
                              fontSize: 23,
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
            ],
          ),
        ),
      ),
    );
  }

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
