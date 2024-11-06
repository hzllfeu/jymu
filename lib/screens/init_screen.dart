import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Alexis/ia_gene.dart';
import 'package:jymu/screens/home/FeedPage.dart';
import 'package:jymu/screens/home/RecherchePage.dart';
import 'package:jymu/Alexis/ia_gene.dart';
import '../Alexis/get_exercise.dart';
import '../Alexis/get_processed.dart';
import '../Alexis/ia_gene.dart';
import '../Alexis/page_zexo.dart';
import '../Models/NotificationService.dart';
import '../Models/UserModel.dart';
import 'ProfilPageBis.dart';
import 'home/HomeScreen.dart';
import 'home/camera.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  final int initialIndex;

  const InitScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}


class _InitScreenState extends State<InitScreen> {
  late int currentSelectedIndex;

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  Future<void> loadProfile() async {
    await UserModel.currentUser().fetchUserData();
    if (UserModel.currentUser().etat_jymupro == 1) {
      await ExerciseDataService.instance.fetchExercises();
      await ProcessedDataService.instance.fetchProcessedData();
    }

  }

  @override
  void initState() {
    super.initState();
    StoredNotification().getNotifications(FirebaseAuth.instance.currentUser!.uid);
    currentSelectedIndex = widget.initialIndex;
    loadProfile();
    /*
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("debug");
      UserModel.currentUser().notificationsloader = StoredNotification().getNotifications(UserModel.currentUser().id!);
    });*/
  }


  List<Widget> pages = [
    Center(
      child: FeedPage(),
    ),
    UserModel.currentUser().etat_jymupro == 1
        ? ExercisePage()
        : IaGene(),

    RecherchePage(id: FirebaseAuth.instance.currentUser!.uid),
    ProfilPageBis(id: FirebaseAuth.instance.currentUser!.uid),
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          CupertinoTabBar(
            onTap: updateCurrentIndex,
            currentIndex: currentSelectedIndex,

            items: [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house, size: 9 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
                activeIcon: Icon(CupertinoIcons.house_fill, color: Colors.redAccent,size: 10 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.command, size: 9 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
                activeIcon: Icon(CupertinoIcons.command, color: Colors.redAccent,size: 10 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.command, size: 5 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),color: Colors.transparent),
                activeIcon: Icon(CupertinoIcons.command, color: Colors.transparent,size: 5 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search, size: 9 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
                activeIcon: Icon(CupertinoIcons.search, color: Colors.redAccent,size: 10 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person, size: 9 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
                activeIcon: Icon(CupertinoIcons.person_fill, color: Colors.redAccent,size: 10 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),),
              ),
            ],
          ),
          Positioned(
            top: -10,
            child: GestureDetector(
              onTapUp: (t) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(),
                  ),
                );
              },
              child: GlassContainer(
                height: MediaQuery.of(context).size.width*0.13,
                width: MediaQuery.of(context).size.width*0.15,
                color: Colors.redAccent.withOpacity(0.5),
                blur: 10,
                borderRadius: BorderRadius.circular(40),
                shadowStrength: 3.5,
                shadowColor: Colors.redAccent.withOpacity(0.9),
                child: Center(
                    child: Image.asset('assets/images/emoji_phone.png', height: 26,)
                ),
              ),
            ),
          ),
        ],
      ),
      body: pages[currentSelectedIndex >= 2 ? currentSelectedIndex-1: currentSelectedIndex],
    );
  }
}
