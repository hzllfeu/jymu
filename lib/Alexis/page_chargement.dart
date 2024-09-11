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
            children: [
              // Flèche pour revenir en arrière
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                  ],
                ),
              ),

              // Titre de la page
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Récap de tes infos",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20, // Taille réduite du titre
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
                            Color(0xffF14BA9).withOpacity(0.7),
                            Colors.redAccent.withOpacity(0.7),
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
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
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
