import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jymu/Nizam/exemple.dart';
import 'package:jymu/screens/home/FeedPage.dart';
import 'package:jymu/screens/home/ProfilPage.dart';

import '../Alexis/exemple.dart';
import 'home/HomeScreen.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

   List<Widget> pages = [
      Center(
      child: FeedPage(),
      ),
      const Center(
        child: Text("Profil"),
      ),
     const Center(
       child: Text("Recherche"),
     ),
      ProfilPage(id: FirebaseAuth.instance.currentUser!.uid),
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: CupertinoTabBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house, size: 28,),
            activeIcon: Icon(CupertinoIcons.house_fill, color: Colors.redAccent,size: 28,),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.command, size: 28,),
            activeIcon: Icon(CupertinoIcons.command, color: Colors.redAccent,size: 28,),
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search, size: 28,),
              activeIcon: Icon(CupertinoIcons.search, color: Colors.redAccent,size: 28,),
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person, size: 28,),
              activeIcon: Icon(CupertinoIcons.person_fill, color: Colors.redAccent,size: 28,),
          ),
        ],
      ),
    );
  }
}
