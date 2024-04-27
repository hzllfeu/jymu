import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class ParrainComp extends StatefulWidget {
  const ParrainComp({super.key});

  static String routeName = "/";

  @override
  State<ParrainComp> createState() => _ParrainCompState();
}

class _ParrainCompState extends State<ParrainComp> {

  bool i = true;
  String nom = "Hugo Vincent";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          Container(
            width: 50,
            height: 6,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20)
            ),
          ),
          const SizedBox(height: 15,),
          const DefaultTextStyle(
            style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w700, fontSize: 29),
            child: Text("Parraine tes gymbros",),
          ),
          Image.asset("assets/images/emoji_hands.png", height: 30,),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DefaultTextStyle(
                style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 20),
                child: Text("A chaque gymbro parrainé, "),
              ),
              Container(
                width: 110,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffF14BA9).withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: const DefaultTextStyle(
                  style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 20),
                  child: Text("2 semaines",),
                ),
              )
            ],
          ),
          const SizedBox(height: 5,),
          const DefaultTextStyle(
            style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 20),
            child: Text("d'abonnement te sont offertes. Et pour", textAlign: TextAlign.center,),
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DefaultTextStyle(
                style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 20),
                child: Text("lui l'entrainement à "),
              ),
              Container(
                width: 170,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffF14BA9).withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: const DefaultTextStyle(
                  style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 20),
                  child: Text("1.99€ seulement.",),
                ),
              )
            ],
          ),
          const SizedBox(height: 40,),
          DefaultTextStyle(
            style: TextStyle(color: Color(0xff37085B).withOpacity(0.6), fontWeight: FontWeight.w500, fontSize: 12),
            child: Text("Code de parrainage", textAlign: TextAlign.center,),
          ),
          const SizedBox(height: 5,),
          CupertinoContextMenu(
            enableHapticFeedback: true,
            previewBuilder: (context, animation, child) => SizedBox(width: 200, height: 150, child: child,),
            actions: const [
              CupertinoContextMenuAction(child: Text("Copier"), trailingIcon: Icons.copy_rounded,),
              CupertinoContextMenuAction(child: Text("Partager votre code"), trailingIcon: CupertinoIcons.share,),
            ],
              child: Container(
                width: 200,
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xffF14BA9), Colors.redAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffF14BA9).withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const DefaultTextStyle(
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24),
                    child: Center(
                      child: DefaultTextStyle(
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24),
                        child: Text("7 0 1 - 4 7 8",),
                      ),
                    )
                ),
              ),
            ),
          SizedBox(height: 15,),
          Container(
              width: double.infinity,
              height: 240,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(0.3),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffF14BA9).withOpacity(0.2), // Couleur de l'ombre
                    spreadRadius: 5, // Rayon de diffusion
                    blurRadius: 7, // Flou de l'ombre
                    offset: Offset(0, 3), // Décalage de l'ombre
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Color(0xffF14BA9), Colors.redAccent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffF14BA9).withOpacity(0.5),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60, // Ajustez la largeur selon vos besoins
                                height: 60, // Ajustez la hauteur selon vos besoins
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    "assets/images/kevin.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const DefaultTextStyle(
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                                child: Text("H. V",),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          width: 100,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Color(0xff37085B).withOpacity(0.8),
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Center(
                            child: Icon(CupertinoIcons.plus, size: 26, color: Color(0xff37085B),),
                          )
                        ),
                      ],
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}
