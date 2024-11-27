import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jymu/Alexis/ia_q1_sexe.dart';
import 'package:jymu/Alexis/ia_init_var_user.dart';

class IntroTimmy extends StatefulWidget {
  const IntroTimmy({super.key});

  @override
  State<IntroTimmy> createState() => _IntroTimmyState();
}

class _IntroTimmyState extends State<IntroTimmy> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final GlobalListManager listManager = GlobalListManager();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond noir en arrière-plan
          Container(
            color: Colors.black87,
          ),
          // Conteneur avec un dégradé en bas de l'écran
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(seconds: 5),
              height: 550, // Hauteur du conteneur en bas
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF3F5F8), // Couleur en haut
                    Color(0xFFF3F5F8), // Couleur en bas
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    spreadRadius: 2,
                    blurRadius: 23,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
            ),
          ),
          // Contenu de la page avec Timmy et le texte
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
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
                                  color: Colors.white.withOpacity(0.2),
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

                        const Icon(CupertinoIcons.arrow_left, size: 28, color: Colors.transparent,),
                      ],
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Image du panda Timmy
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(75),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.7),
                                spreadRadius: 4,
                                blurRadius: 7,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: Image.asset(
                              'assets/images/timmy_panda.png', // Remplacez par le chemin de votre image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 115),
                        // Texte principal
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Ah oui, et une dernière chose...",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.8),
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Texte description Timmy
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Rencontrez Timmy, notre adorable assistant panda ! 🐼\n\n"
                                "Timmy va vous accompagner tout au long du questionnaire. Il est là pour rendre votre expérience agréable et s'assurer que vous recevez un programme parfaitement personnalisé. Ne vous inquiétez pas, Timmy est là pour vous aider à chaque étape du processus !",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.7),
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          listManager.dynamicList[0] = 0.0;
                          listManager.dynamicList[1] = 0.0;
                          listManager.dynamicList[2] = 0.0;
                          listManager.dynamicList[3] = 0.0;
                          listManager.dynamicList[4] = 0.0;
                          listManager.dynamicList[5] = 0.0;
                          listManager.dynamicList[6] = 0.0;
                          listManager.dynamicList[7] = 0.0;
                          listManager.dynamicList[8] = 0.0;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionSexee(),
                          ),
                        );
                      },
                      child: Container(
                        height: 70,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.redAccent,
                              Colors.redAccent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 4,
                              blurRadius: 8,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20), // Padding horizontal ajouté
                            child: Text(
                              "Suivant",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Ajusté l'espacement en bas
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
