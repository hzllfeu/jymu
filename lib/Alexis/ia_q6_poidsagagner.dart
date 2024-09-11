import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Alexis/ia_q7_hautbas.dart';
import 'package:jymu/Alexis/ia_init_var_user.dart';
import 'package:jymu/screens/init_screen.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class QuestionPoidd extends StatefulWidget {
  const QuestionPoidd({super.key});

  static String routeName = "/";

  @override
  State<QuestionPoidd> createState() => _QuestionPoiddState();
}

class _QuestionPoiddState extends State<QuestionPoidd> {
  final GlobalListManager listManager = GlobalListManager();

  int ob = 0;
  double valeur_progbarre = 200;

  String getWeightMessage() {
    if (ob <= 0) {
      return "Vous souhaitez perdre ${-ob} kilos";
    } else {
      return "Vous souhaitez gagner $ob kilos";
    }
  }

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
                          child: Image.asset('assets/images/emoji_leftarrow.png', height: 24),
                        ),
                      ),
                    ),
                    Container(
                      height: 28,
                      width: valeur_progbarre,
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
                            width: 6 * valeur_progbarre / 8,
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
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 1),
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
                      "Plus que 2 questions...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Combien de kilos souhaites tu prendre/perdre ?",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
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
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    getWeightMessage(),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTapUp: (t) {
                                setState(() {
                                  listManager.dynamicList[1] = ob.toDouble();
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuestionFocusCorps(),
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
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
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
                              ob = value - 20;
                            });
                          },
                          scrollController: FixedExtentScrollController(
                            initialItem: 20,
                          ),
                          children: List<Widget>.generate(
                            41,
                                (index) => Text("${index - 20}"),
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
