import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Alexis/ia_gene.dart';
import 'package:jymu/Alexis/ia_init_var_user.dart';
import 'package:jymu/Alexis/page_paiement.dart';

class LoadingPage extends StatelessWidget {
  final GlobalListManager listManager = GlobalListManager();

  LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Titre de la page
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Chargement des paramètres",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Liste dynamique affichée de manière propre
              Expanded(
                child: ListView.builder(
                  itemCount: listManager.dynamicList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: GlassContainer(
                        height: 50,
                        width: double.infinity,
                        blur: 5,
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        shadowColor: Colors.black,
                        shadowStrength: 1.0,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.withOpacity(0.6),
                            Colors.greenAccent.withOpacity(0.6),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Paramètre ${index + 1}: ${listManager.dynamicList[index].toStringAsFixed(1)}",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bouton "Suivant"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GlassContainer(
                  height: 50,
                  width: double.infinity,
                  blur: 5,
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                  shadowColor: Colors.black,
                  shadowStrength: 1.0,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange.withOpacity(0.6),
                      Colors.pinkAccent.withOpacity(0.6),
                    ],
                  ),
                  child: GestureDetector(
                    onTapUp: (t) {
                      // Action à effectuer lorsque le bouton "Suivant" est pressé
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Paiements(),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        "Suivant",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
