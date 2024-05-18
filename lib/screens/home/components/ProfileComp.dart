import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class ProfileComp extends StatefulWidget {
  const ProfileComp({super.key});

  static String routeName = "/";

  @override
  State<ProfileComp> createState() => _ProfileCompState();
}

class _ProfileCompState extends State<ProfileComp> {

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
          const SizedBox(height: 30,),
          CupertinoContextMenu(
              enableHapticFeedback: true,
              previewBuilder: (context, animation, child) => SizedBox(width: 300, child: child,),
              actions: const [
                CupertinoContextMenuAction(child: Text("Partager votre carte"), trailingIcon: CupertinoIcons.share,)
              ],
              child: Container(
                width: double.infinity,
                height: 230,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xffF14BA9), Colors.redAccent], //[[Colors.amberAccent, Colors.deepOrangeAccent] couleurs jymupro
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
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
                    Column(
                      children: [
                        DefaultTextStyle(
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 26),
                          child: Text(nom,),
                        ),
                        const SizedBox(height: 5,),
                        const DefaultTextStyle(
                          style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w700, fontSize: 14),
                          child: Text("72 kg, 1M80",),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 30,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DefaultTextStyle(
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                                child: Text("Jymrat",),
                              ),
                              Image.asset(
                                "assets/images/emoji_goat.png",
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Container(
                          width: 108,
                          height: 30,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DefaultTextStyle(
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                                child: Text("JymuPro",),
                              ),
                              Image.asset(
                                "assets/images/emoji_fire.png",
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
          ),
          const SizedBox(height: 30,),
          Container(
            width: double.infinity,
            height: 310,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(0.3)
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Color(0xff37085B)),
                        child: Text("Votre compte",),
                      ),
                      Icon(CupertinoIcons.settings_solid, color: Color(0xff37085B), size: 25,)
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(CupertinoIcons.headphones, color: Color(0xff37085B), size: 24,),
                      SizedBox(width: 10,),
                      DefaultTextStyle(
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: Color(0xff37085B)),
                        child: Text("Vous avez un probléme ?",),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(CupertinoIcons.person_badge_plus, color: Color(0xff37085B), size: 24,),
                      SizedBox(width: 10,),
                      DefaultTextStyle(
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: Color(0xff37085B)),
                        child: Text("Traitement de vos données",),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(CupertinoIcons.house, color: Color(0xff37085B), size: 24,),
                      SizedBox(width: 10,),
                      DefaultTextStyle(
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: Color(0xff37085B)),
                        child: Text("A propos de Olympik",),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed, size: 24,),
                      SizedBox(width: 10,),
                      DefaultTextStyle(
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: CupertinoColors.destructiveRed),
                        child: Text("Supprimer votre compte",),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
