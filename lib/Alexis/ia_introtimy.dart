import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jymu/Alexis/ia_q1_sexe.dart';

class IntroTimmy extends StatefulWidget {
  const IntroTimmy({super.key});

  @override
  State<IntroTimmy> createState() => _IntroTimmyState();
}

class _IntroTimmyState extends State<IntroTimmy> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

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
                      "Rencontrez Timy !",
                      style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const Icon(CupertinoIcons.arrow_left, size: 28, color: Colors.transparent,),
                  ],
                ),
              ),
              Spacer(),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // Image du panda Timmy
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 4,
                            blurRadius: 8,
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
                    SizedBox(height: 40),
                    Text(
                      "Ah oui, et une dernière chose...",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.8),
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
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
                  ],
                ),
              ),
              SizedBox(height: 80), // Augmenté l'espacement en bas pour remonter le bouton
              ScaleTransition(
                scale: _scaleAnimation,
                child: GestureDetector(
                  onTap: () {
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
                          Colors.pinkAccent.withOpacity(0.8),
                          Colors.orangeAccent.withOpacity(0.8),
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
                      child: Text(
                        "Suivant",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
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
    );
  }
}
