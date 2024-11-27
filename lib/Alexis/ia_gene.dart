import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Alexis/ia_introtimy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

const Color inActiveIconColor = Color(0xFFFFC0CB);
const Color checkboxColor = Color(0xFF00C853); // Couleur de la case à cocher

class IaGene extends StatefulWidget {
  const IaGene({super.key});

  static String routeName = "/";

  @override
  State<IaGene> createState() => _IaGeneState();
}

class _IaGeneState extends State<IaGene> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isAccepted = false; // État de la checkbox

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black87, // Fond noir
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(seconds: 5),
              height: 230 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), // Hauteur du conteneur
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF3F5F8),
                    Color(0xFFF3F5F8),
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Suppression du Row contenant les deux boutons inutiles
                  Padding(
                    padding: EdgeInsets.only(top: 30 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), bottom: 30),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            "Trouve des exercices adaptés à tes besoins.",
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 7),
                          Text(
                            "(Questionnaire propulsé par l'IA)",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 55 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
                          Lottie.asset('assets/animations/fleche.json', height: 90 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20), // Ajuste la valeur ici
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: GlassContainer(
                        // Le contenu de GlassContainer reste inchangé
                      ),
                    ),
                  ),

                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Transform.translate(
                      offset: Offset(0, -30), // Remonte de 20 pixels
                      child: GlassContainer(
                        height: 100 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                        width: double.infinity,
                        blur: 20,
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                        shadowColor: Colors.black.withOpacity(0.2),
                        shadowStrength: 2,
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xffF14BA9).withOpacity(0.7),
                            Colors.redAccent.withOpacity(0.7),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  "Prêt à démarrer !",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CupertinoCheckbox(
                                    value: _isAccepted,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        _isAccepted = newValue ?? false;
                                      });
                                    },
                                    activeColor: checkboxColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "J'accepte les conditions générales d'utilisation.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
                              GestureDetector(
                                onTap: () {
                                  if (_isAccepted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const IntroTimmy(),
                                      ),
                                    );
                                  } else {
                                    _showAcceptanceAlert(context);
                                  }
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
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black38,
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: Offset(2, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Commencer",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAcceptanceAlert(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Conditions d'utilisation"),
          content: Text("Veuillez accepter les conditions générales d'utilisation pour continuer."),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
