import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jymu/Alexis/ia_gene.dart';
import 'package:jymu/screens/Questions/QuestionSexe.dart';
import 'package:jymu/screens/home/FeedPage.dart';
import 'package:jymu/screens/home/ProfilPage.dart';
import 'package:jymu/screens/home/RecherchePage.dart';
import 'package:jymu/Alexis/ia_gene.dart';
import '../Alexis/ia_gene.dart';
import 'home/HomeScreen.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  final int initialIndex; // Ajoute ce paramètre

  const InitScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}


class _InitScreenState extends State<InitScreen> {
  late int currentSelectedIndex; // Utilise late pour initialiser plus tard

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    currentSelectedIndex = widget.initialIndex;
  }


   List<Widget> pages = [
      Center(
      child: FeedPage(),
      ),
      IaGene(),
      RecherchePage(id: FirebaseAuth.instance.currentUser!.uid),
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

        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house, size: 10 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
            activeIcon: Icon(CupertinoIcons.house_fill, color: Colors.redAccent,size: 11 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.command, size: 10 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
            activeIcon: Icon(CupertinoIcons.command, color: Colors.redAccent,size: 11 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search, size: 10 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
              activeIcon: Icon(CupertinoIcons.search, color: Colors.redAccent,size: 11 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person, size: 10 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
              activeIcon: Icon(CupertinoIcons.person_fill, color: Colors.redAccent,size: 11 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
          ),
        ],
      ),
    );
  }
}
