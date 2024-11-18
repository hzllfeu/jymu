import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:jymu/Alexis/ia_gene.dart';
import 'package:jymu/screens/home/FeedPage.dart';
import 'package:jymu/screens/home/RecherchePage.dart';
import 'package:jymu/Alexis/ia_gene.dart';
import '../Alexis/get_exercise.dart';
import '../Alexis/get_processed.dart';
import '../Alexis/ia_gene.dart';
import '../Alexis/page_zexo.dart';
import '../Models/CachedData.dart';
import '../Models/NotificationService.dart';
import '../Models/TrainingModel.dart';
import '../Models/UserModel.dart';
import 'ProfilPageBis.dart';
import 'home/HomeScreen.dart';
import 'home/NotifListComp.dart';
import 'home/camera.dart';
import 'home/components/TrainingPage.dart';

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
  Future<void>? data;

  List<String> getPostIdsForToday(List<dynamic> posts) {
    DateTime today = DateTime.now();
    DateTime todayStart = DateTime(today.year, today.month, today.day);

    List<String> todayPostIds = [];

    for (var post in posts) {
      if (post['timestamp'] is Timestamp) {
        DateTime postDate = (post['timestamp'] as Timestamp).toDate();

        // Vérifiez si le post a été créé aujourd'hui
        if (postDate.isAfter(todayStart) && postDate.isBefore(todayStart.add(Duration(days: 1)))) {
          todayPostIds.add(post['training']); // Ajoutez l'ID du post à la liste
        }
      }
    }

    return todayPostIds; // Retourne la liste des IDs trouvés
  }

  bool tdypostbool = false;

  bool finished = false;

  List<TrainingModel> postslist = [];
  List<File?> imagelist = [];

  bool showposts  = false;

  Future<void> getPostData() async{
    await UserModel.currentUser().fetchUserData();
    List<String> tdypostid = getPostIdsForToday(UserModel.currentUser().trainings!);
    if(tdypostid.isNotEmpty){
      for(String s in tdypostid){
        TrainingModel tmp = TrainingModel();
        File? imgtmp;
        if (CachedData().trainings.containsKey(s)) {
          tmp = CachedData().trainings[s]!;
        } else {
          await tmp.fetchExternalData(s);
          CachedData().trainings[s] = tmp;
        }
        if(CachedData().images.containsKey(tmp.firstImage!)){
          imgtmp = CachedData().images[tmp.firstImage!]!;
        } else {
          imgtmp = (await getImage(tmp.firstImage!))!;
          CachedData().images[tmp.firstImage!] = imgtmp!;
        }
        postslist.add(tmp);
        imagelist.add(imgtmp);
      }

      tdypostbool = true;
      setState(() {

      });
    }
  }

  void updateCurrentIndex(int index) {
    if(index == 2) {
      return;
    }
    if(showposts){
      return;
    }
    setState(() {
      currentSelectedIndex = index;
    });
  }

  Future<void> loadProfile() async {
    if (UserModel.currentUser().etat_jymupro == 1) {
      await ExerciseDataService.instance.fetchExercises();
      await ProcessedDataService.instance.fetchProcessedData();
    }

  }

  @override
  void initState() {
    super.initState();
    currentSelectedIndex = widget.initialIndex;
    loadProfile();
    data = getPostData();
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
        ? const ExercisePage()
        : const IaGene(),

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
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHome09,
                  color: Colors.black.withOpacity(0.6),
                  size: 18,
                ),
                activeIcon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedHome09,
                  color: Colors.redAccent,
                  size: 20,
                ),
              ),
              BottomNavigationBarItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedArtificialIntelligence04,
                  color: Colors.black.withOpacity(0.6),
                  size: 20,
                ),
                activeIcon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedArtificialIntelligence04,
                  color: Colors.redAccent,
                  size: 22,
                ),
              ),
              const BottomNavigationBarItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHome09,
                  color: Colors.transparent,
                  size: 20,
                ),
                activeIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHome09,
                  color: Colors.transparent,
                  size: 22,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search, size: 18, color: Colors.black.withOpacity(0.6),),
                activeIcon: const Icon(CupertinoIcons.search, color: Colors.redAccent,size: 19,),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person, size: 18, color: Colors.black.withOpacity(0.6),),
                activeIcon: const Icon(CupertinoIcons.person_fill, color: Colors.redAccent,size: 19,),
              ),
            ],
          ),
          if(tdypostbool)
            Positioned(
              top: -30,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          const Positioned(
                            child: SizedBox(width: 0, height: 0),
                          ),
                          // Premier élément
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 800),
                            right: showposts ? postslist.length == 1 ? 45 : 100 : postslist.length == 1 ? -20 : postslist.length == 2 ? -25 : -30,
                            bottom: showposts ? 300 : -75,
                            curve: Curves.easeOutExpo,
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 500),
                              scale: showposts ? 1.6 : 1.0,
                              curve: Curves.easeInOut,
                              child: Column(
                                children: [
                                  Hero(
                                    tag: "feed${postslist[0].id}",
                                    child: Container(
                                      width: 60,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.white54,
                                          width: 2,
                                        ),
                                        image: DecorationImage(
                                          image: Image.file(imagelist[0]!).image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if(showposts)
                                    const SizedBox(height: 9,),
                                  if(showposts)
                                    ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width*0.2
                                    ),
                                    child: GlassContainer(
                                      color: Colors.black.withOpacity(0.5),
                                      blur: 10,
                                      borderRadius: BorderRadius.circular(18),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                DateTime.now().day != postslist[0].date?.toDate().day
                                                    ? formatDate(postslist[0].date!.toDate())
                                                    : "${postslist[0].date?.toDate().hour.toString().padLeft(2, '0')}:${postslist[0].date?.toDate().minute.toString().padLeft(2, '0')}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10,
                                                  color: Colors.white.withOpacity(0.9),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ),
                          ),
                          if (postslist.length > 1)
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 800),
                              right:  showposts ?  -20 : postslist.length == 2 ? -15 : -20,
                              bottom: showposts ? 300 : -75,
                              curve: Curves.easeOutExpo,
                              child: GestureDetector(
                                onTapUp: (t) {
                                  Haptics.vibrate(HapticsType.light);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrainingPage(
                                        trn: postslist[1],
                                        type: "feed",
                                      ),
                                    ),
                                  );
                                },
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 500),
                                  scale: showposts ? 1.6 : 1.0,
                                  curve: Curves.easeInOut,
                                  child: Column(
                                    children: [
                                      Hero(
                                        tag: "feed${postslist[1].id}",
                                        child: Container(
                                          width: 60,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.white54,
                                              width: 2,
                                            ),
                                            image: DecorationImage(
                                              image: Image.file(imagelist[1]!).image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if(showposts)
                                        const SizedBox(height: 9,),
                                      if(showposts)
                                        ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width*0.2
                                        ),
                                        child: GlassContainer(
                                          color: Colors.black.withOpacity(0.5),
                                          blur: 10,
                                          borderRadius: BorderRadius.circular(18),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    DateTime.now().day != postslist[1].date?.toDate().day
                                                        ? formatDate(postslist[1].date!.toDate())
                                                        : "${postslist[1].date?.toDate().hour.toString().padLeft(2, '0')}:${postslist[1].date?.toDate().minute.toString().padLeft(2, '0')}",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 10,
                                                      color: Colors.white.withOpacity(0.9),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ),
                              )
                            ),
                          if (postslist.length > 2)
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 800),
                              right: showposts ? -140 : -10,
                              bottom: showposts ? 300 : -75,
                              curve: Curves.easeOutExpo,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 500),
                                scale: showposts ? 1.6 : 1.0,
                                curve: Curves.easeInOut,
                                child: Column(
                                  children: [
                                    Hero(
                                      tag: "feed${postslist[2].id}",
                                      child: Container(
                                        width: 60,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.white54,
                                            width: 2,
                                          ),
                                          image: DecorationImage(
                                            image: Image.file(imagelist[2]!).image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if(showposts)
                                      const SizedBox(height: 9,),
                                    if(showposts)
                                      ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width*0.2
                                      ),
                                      child: GlassContainer(
                                        color: Colors.black.withOpacity(0.5),
                                        blur: 10,
                                        borderRadius: BorderRadius.circular(18),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  DateTime.now().day != postslist[2].date?.toDate().day
                                                      ? formatDate(postslist[2].date!.toDate())
                                                      : "${postslist[2].date?.toDate().hour.toString().padLeft(2, '0')}:${postslist[2].date?.toDate().minute.toString().padLeft(2, '0')}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10,
                                                    color: Colors.white.withOpacity(0.9),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ),
                            ),
                          if(postslist.length == 2)
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 800),
                              right: showposts ? -140 : -10,
                              bottom: showposts ? 340 : -75,
                              curve: Curves.easeOutExpo,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 500),
                                scale: showposts ? 1.6 : 0,
                                curve: Curves.easeInOut,
                                child: CustomPaint(
                                  painter: DottedBorderPainter(color: Colors.black38),
                                  child: Container(
                                    width: 60,
                                    height: 70,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        HugeIcon(
                                          icon: HugeIcons.strokeRoundedAddSquare,
                                          color: Colors.black38,
                                          size: 16,
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          "1 post restant",
                                          style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ),
                            ),
                          if(postslist.length == 1)
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 800),
                              right: showposts ? -95 : -10,
                              bottom: showposts ? 340 : -75,
                              curve: Curves.easeOutExpo,
                              child: AnimatedScale(
                                  duration: const Duration(milliseconds: 500),
                                  scale: showposts ? 1.6 : 0,
                                  curve: Curves.easeInOut,
                                  child: CustomPaint(
                                    painter: DottedBorderPainter(color: Colors.black38),
                                    child: Container(
                                      width: 60,
                                      height: 70,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          HugeIcon(
                                            icon: HugeIcons.strokeRoundedAddSquare,
                                            color: Colors.black38,
                                            size: 16,
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            "2 posts restants",
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            ),

                          AnimatedPositioned(
                              duration: const Duration(milliseconds: 800),
                              bottom: showposts ? 500 : -75,
                              curve: Curves.easeOutExpo,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 400),
                                scale: showposts ? 1.6 : 0,
                                curve: Curves.easeInOut,
                                child: GlassContainer(
                                  color: Colors.black.withOpacity(0.5),
                                  blur: 10,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Tes posts aujourd'hui",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10,
                                              color: Colors.white.withOpacity(0.9),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                  ),
                ),
              )
            )
          else
            FutureBuilder(
              future: data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Positioned(top: -30,
                    child: Container(
                      width: 60,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffe6e5e3)
                      ),
                      child: const Center(
                        child: CupertinoActivityIndicator(radius: 8, color: Colors.black87,),
                      ),
                    )
                    );
                } else if (snapshot.hasError) {
                  return const SizedBox();
                } else if(!tdypostbool){
                  return Positioned(
                    top: -30,
                    child: GestureDetector(
                      onTapUp: (t) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffe6e5e3)
                        ),
                        child: const Center(
                          child: Icon(CupertinoIcons.plus_app, color: Colors.redAccent, size: 18,),
                        ),
                      )
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

          if(tdypostbool)
            Positioned(
            top: -30,
            child: GestureDetector(
              onTapUp: (t) {
                Haptics.vibrate(HapticsType.medium);
                /*
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrainingPage(trn: tdytrn, type: "feed",),
                              ),
                            );

                             */

                setState(() {
                  showposts = true;
                });
              },
              child: Container(
                color: Colors.transparent,
                width: 120,
                height: 80,
              )
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          pages[currentSelectedIndex >= 2 ? currentSelectedIndex-1: currentSelectedIndex],
          IgnorePointer(
            ignoring: !showposts,
            child: AnimatedOpacity(
              opacity: showposts ? 1 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapUp: (t){
                  setState(() {
                    showposts = false;
                  });
                },
                child: GlassContainer(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: const Color(0xFFF3F5F8).withOpacity(0.7),
                  blur: 10,

                ),
              )
            ),
          ),
          if (tdypostbool && showposts)
            Positioned(
              bottom: 310,
              left: postslist.length == 1 ? 105 : 50,
              child: Listener(
                onPointerUp: (event) {
                  Haptics.vibrate(HapticsType.light);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainingPage(
                        trn: postslist[0],
                        type: "feed",
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  width: 90,
                  height: 140,
                ),
              ),
            ),
          if (tdypostbool && showposts)
            Positioned(
              bottom: postslist.length == 1 ? 350 : 310,
              right: postslist.length == 1 ? 95 : null,
              child: Listener(
                onPointerUp: (event) {
                  if(postslist.length > 1){
                    Haptics.vibrate(HapticsType.light);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainingPage(
                          trn: postslist[1],
                          type: "feed",
                        ),
                      ),
                    );
                  } else if(postslist.length == 1){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraPage(),
                      ),
                    );
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  width: 90,
                  height: 140,
                ),
              ),
            ),
          if (tdypostbool && showposts && postslist.length > 1)
            Positioned(
              bottom: postslist.length == 2 ? 350 : 310,
              right: 50,
              child: Listener(
                onPointerUp: (event) {
                  if(postslist.length > 2){
                    Haptics.vibrate(HapticsType.light);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainingPage(
                          trn: postslist[2],
                          type: "feed",
                        ),
                      ),
                    );
                  } else if(postslist.length == 2){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraPage(),
                      ),
                    );
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  width: 90,
                  height: 140,
                ),
              ),
            ),
          if(tdypostbool)
            Positioned(
              bottom: 0,
              child: GestureDetector(
                  onTapUp: (t) {
                    Haptics.vibrate(HapticsType.medium);
                    setState(() {
                      showposts = true;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: 120,
                    height: 30,
                  )
              ),
            ),
        ],
      )
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  DottedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashWidth = 7.0,
    this.dashGap = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(10),
    ));

    final dashPath = Path();
    final dashPainter = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double dashOffset = 0;
    while (dashOffset < path.computeMetrics().first.length) {
      final dashPathMetric = path.computeMetrics().first;
      final extractPath = dashPathMetric.extractPath(
        dashOffset,
        dashOffset + dashWidth,
      );
      dashPath.addPath(extractPath, Offset.zero);
      dashOffset += dashWidth + dashGap;
    }
    canvas.drawPath(dashPath, dashPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
