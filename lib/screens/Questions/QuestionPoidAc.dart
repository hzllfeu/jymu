import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../Onboarding/paiment.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class QuestionPoidAc extends StatefulWidget {

  final int poidobj;
  final int sexe;
  final int obj;
  final int taille;

  const QuestionPoidAc({super.key, required this.sexe, required this.poidobj, required this.obj, required this.taille});

  static String routeName = "/";

  @override
  State<QuestionPoidAc> createState() => _QuestionPoidAcState();
}

class _QuestionPoidAcState extends State<QuestionPoidAc> {

  int ob = 45;
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
                      child: const Icon(CupertinoIcons.arrow_left, size: 28),
                    ),                    Text(
                      "Etape 8/22",
                      style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const Icon(CupertinoIcons.arrow_left, size: 28, color: Colors.transparent,),
                  ],
                ),
              ),

              const SizedBox(height: 50,),
              Column(
                children: [
                  Image.asset("assets/images/emoji_balance.png", height: 32,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Quelle est votre poid actuel ?",
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
                                        "Vous pesez $ob kgs",
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
                                      builder: (context) => Paiement(sexe: widget.sexe, poidobj: widget.poidobj, obj: widget.obj, taille: widget.taille, poid: ob,),
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
                                  ob = value + 45;
                                });
                              },
                              scrollController: FixedExtentScrollController(
                                  initialItem: 0
                              ),
                              children: const [
                                Text("45"),
                                Text("46"),
                                Text("47"),
                                Text("48"),
                                Text("49"),
                                Text("50"),
                                Text("51"),
                                Text("52"),
                                Text("53"),
                                Text("54"),
                                Text("55"),
                                Text("56"),
                                Text("57"),
                                Text("58"),
                                Text("59"),
                                Text("60"),
                                Text("61"),
                                Text("62"),
                                Text("63"),
                                Text("64"),
                                Text("65"),
                                Text("66"),
                                Text("67"),
                                Text("68"),
                                Text("69"),
                                Text("70"),
                                Text("71"),
                                Text("72"),
                                Text("73"),
                                Text("74"),
                                Text("75"),
                                Text("76"),
                                Text("77"),
                                Text("78"),
                                Text("79"),
                                Text("80"),
                                Text("81"),
                                Text("82"),
                                Text("83"),
                                Text("84"),
                                Text("85"),
                                Text("86"),
                                Text("87"),
                                Text("88"),
                                Text("89"),
                                Text("90"),
                                Text("91"),
                                Text("92"),
                                Text("93"),
                                Text("94"),
                                Text("95"),
                                Text("96"),
                                Text("97"),
                                Text("98"),
                                Text("99"),
                                Text("100"),
                                Text("101"),
                                Text("102"),
                                Text("103"),
                                Text("104"),
                                Text("105"),
                                Text("106"),
                                Text("107"),
                                Text("108"),
                                Text("109"),
                                Text("110"),
                                Text("111"),
                                Text("112"),
                                Text("113"),
                                Text("114"),
                                Text("115"),
                                Text("116"),
                                Text("117"),
                                Text("118"),
                                Text("119"),
                                Text("120"),
                                Text("121"),
                                Text("122"),
                                Text("123"),
                                Text("124"),
                                Text("125"),
                                Text("126"),
                                Text("127"),
                                Text("128"),
                                Text("129"),
                                Text("130"),
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
