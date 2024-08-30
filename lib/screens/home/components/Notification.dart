import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class Notification1 extends StatefulWidget {
  const Notification1({super.key});

  static String routeName = "/";

  @override
  State<Notification1> createState() => _Notification1State();
}

class _Notification1State extends State<Notification1> {
  String nom = "Hugo Vincent";

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
        enableHapticFeedback: true,
        actions: const [
        CupertinoContextMenuAction(child: Text("Supprimer"), trailingIcon: CupertinoIcons.delete, isDestructiveAction: true,)
        ],
        child: Container(
        width: double.infinity,
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                  Image.asset("assets/images/emoji_hands.png", height: 26,),
                ],
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: DefaultTextStyle(
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                    child: Text("Hugo vincent a accépté votre parrainage !"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.greenAccent, Colors.green],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    const DefaultTextStyle(
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                      child: Text("Mardi"),
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
