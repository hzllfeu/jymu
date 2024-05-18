import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class ExoTemplate extends StatefulWidget {
  const ExoTemplate({super.key});

  static String routeName = "/";

  @override
  State<ExoTemplate> createState() => _ExoTemplateState();
}

class _ExoTemplateState extends State<ExoTemplate> {
  String nom = "Hugo Vincent";

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
        enableHapticFeedback: true,
        previewBuilder: (context, animation, child) => SizedBox(width: 360, child: child,),
        actions: const [
          CupertinoContextMenuAction(child: Text("Ajouter a l'entrainement"), trailingIcon: CupertinoIcons.add, isDestructiveAction: false,),
          CupertinoContextMenuAction(child: Text("Retirer de l'entrainement"), trailingIcon: CupertinoIcons.delete, isDestructiveAction: true,),
        ],
        child: Container(
          width: double.infinity,
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xffF84E71).withOpacity(0.7), Colors.redAccent.withOpacity(0.7)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xffF14BA9).withOpacity(0.5),
                spreadRadius: 6,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
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
                      Image.asset("assets/images/emoji_muscle.png", height: 26,),
                    ],
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const DefaultTextStyle(
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                            child: Text("Tirage horizontal"),
                          ),
                          const SizedBox(width:7,),
                          DefaultTextStyle(
                            style: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500, fontSize: 14),
                            child: Text("Dos"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      DefaultTextStyle(
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600, fontSize: 14),
                        child: Text("Machine: poulie haute"),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [Colors.white, Colors.orange],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds);
                      },
                      child: const DefaultTextStyle(
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
                        child: Text("94%"),
                      ),
                    ),
                    const DefaultTextStyle(
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                      child: Text("Utilisé"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
