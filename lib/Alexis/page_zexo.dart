import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import 'package:jymu/screens/init_screen.dart';

class ExercisePage extends StatelessWidget {
  ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Titre de la page
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Vos Exos",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Bouton "Retour"
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
                      // Action à effectuer lorsque le bouton "Retour" est pressé
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        "Retour",
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
        ),
      ),
    );
  }
}
