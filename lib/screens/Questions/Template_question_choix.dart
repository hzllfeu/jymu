import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class QuestionChoix extends StatefulWidget {
  const QuestionChoix({super.key});

  static String routeName = "/";

  @override
  State<QuestionChoix> createState() => _QuestionChoixState();
}

class _QuestionChoixState extends State<QuestionChoix> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(CupertinoIcons.arrow_left, size: 28,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      const SizedBox(height: 5,),
                      const Text(
                        "(Estimation de votre niveau par l'IA)",
                        style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w500, fontSize: 10),
                      )
                    ],
                  ),
                  const Icon(CupertinoIcons.arrow_left, size: 28, color: Colors.transparent,),
                ],
              ),
              const SizedBox(height: 100,),
              const Text(
                "Ceci est une question portant sur vous ?",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          height: 70,
                          width: 180,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.redAccent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3), // Couleur de l'ombre
                                spreadRadius: 3, // Rayon de diffusion
                                blurRadius: 7, // Flou de l'ombre
                                offset: Offset(0, 3), // Décalage de l'ombre
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Réponse 1",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              Image.asset("assets/images/emoji_carrot.png", height: 26,)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          height: 70,
                          width: 180,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.deepOrangeAccent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3), // Couleur de l'ombre
                                spreadRadius: 3, // Rayon de diffusion
                                blurRadius: 7, // Flou de l'ombre
                                offset: Offset(0, 3), // Décalage de l'ombre
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Réponse 2",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              Image.asset("assets/images/emoji_leg.png", height: 26,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          height: 70,
                          width: 180,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.deepOrangeAccent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3), // Couleur de l'ombre
                                spreadRadius: 3, // Rayon de diffusion
                                blurRadius: 7, // Flou de l'ombre
                                offset: Offset(0, 3), // Décalage de l'ombre
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Réponse 3",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              Image.asset("assets/images/emoji_running.png", height: 26,)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          height: 70,
                          width: 180,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.redAccent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3), // Couleur de l'ombre
                                spreadRadius: 3, // Rayon de diffusion
                                blurRadius: 7, // Flou de l'ombre
                                offset: Offset(0, 3), // Décalage de l'ombre
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Réponse 4",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              Image.asset("assets/images/emoji_muscle.png", height: 26,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 250,),
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.orange, Colors.redAccent],
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(CupertinoIcons.arrow_right, color: Colors.transparent, size: 30,),
                      Text(
                        "Suivant",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                      ),

                      Icon(CupertinoIcons.arrow_right, color: Colors.white, size: 30,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
