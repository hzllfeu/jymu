import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:jymu/Models/TrainingModel.dart';
import 'package:jymu/PostManager.dart';
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/home/LoadingPost.dart';
import 'package:jymu/screens/home/LoadingProfileList.dart';
import 'package:jymu/screens/home/LoadingTraining.dart';
import 'package:jymu/screens/home/PostWidget.dart';

import 'package:jymu/screens/home/components/NotificationPage.dart';
import 'package:jymu/screens/home/components/PostCard.dart';
import 'package:jymu/screens/home/components/ProfileComp.dart';
import 'package:jymu/screens/home/components/SelectPost.dart';
import 'package:jymu/screens/home/components/training_home.dart';
import 'package:jymu/screens/home/settings/AllSettings.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

import '../../Models/CachedData.dart';
import '../../Models/NotificationService.dart';
import '../../Models/UserModel.dart';
import 'NotifListComp.dart';
import 'TrainingCard.dart';
import 'camera.dart';
import 'components/TrainingPage.dart';
import 'components/custom_rect_tween.dart';
import 'components/hero_dialog_route.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class FeedPage extends StatefulWidget {
  FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {
  bool isFirstSelected = true;
  List<String> listPosts = [];
  List<String> LoadedPosts = [];
  final Map<int, TrainingCard> cachedTrainings = {};
  final Map<int, TrainingModel> cachedTrainingsModels = {};
  int counter = 0;
  int lastcounter = 0;
  late PreloadPageController pc;
  late PreloadPageController pcbis;
  bool loading = false;
  int _previousPage = 0;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool notifvisible = false;


  @override
  void initState() {
    super.initState();
    pc = PreloadPageController();
    pcbis = PreloadPageController();
    pc.addListener(scrollListener);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    startAnim();

    loadTrainingModels();

    refresher();
  }

  void scrollListener() {
    int index = pc.page!.toInt();
    if(index != _previousPage){
      setState(() {
        _previousPage = index;
      });

      if(index > counter - 2 && !loading && counter > 0 && feedfiends){
        loadTrainingModels();
      }

    }
  }

  Future<void> refresher() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
    });
  }

  Future<void> startAnim() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      notifvisible = true;
    });
    _controller.reset();
    _controller.forward();
  }

  bool animpostedpos = false;

  Future<void> animPosted() async {
    setState(() {
      animpostedpos = true;
    });
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      animpostedpos = false;
    });
  }


  TrainingModel tdytrn = TrainingModel();
  bool tdypostbool = false;
  File? tdyimage;

  bool finished = false;

  Future<void> loadTrainingModels() async {
    setState(() {

    });
    String idtmp = UserModel.currentUser().id ?? "";
    while(idtmp.isEmpty){
      await Future.delayed(const Duration(milliseconds: 500));
      idtmp = UserModel.currentUser().id ?? "";
    }
    if(loading){
      return;
    }

    loading = true;
    List<String> tmp = await getTrainingsForUser(3, listPosts);
    listPosts.addAll(tmp);
    listPosts.where((id) => id != "default").toSet().toList();

    lastcounter = counter;

    setState(() {

    });

    for (int i = lastcounter; i < listPosts.length; i++) {
      String s = listPosts[counter];
      TrainingModel tmp = TrainingModel();

      if (CachedData().trainings.containsKey(s)) {
        tmp = CachedData().trainings[s]!;
      } else {
        await tmp.fetchExternalData(s);
        CachedData().trainings[s] = tmp;
      }
      setState(() {
        cachedTrainingsModels[counter] = tmp;
        counter++;
      });
    }
    setState(() {
      finished = true;
    });

    await loadTrainings();

    if(counter == 0){
      setState(() {
        feedtrend = true;
        feedfiends = false;
        feedfyp = false;
        changefeed = false;
      });
      loadTrendings();
    }
  }

  Future<void> loadTrendings() async {
    setState(() {

    });
    String idtmp = UserModel.currentUser().id ?? "";
    while(idtmp.isEmpty){
      await Future.delayed(const Duration(milliseconds: 500));
      idtmp = UserModel.currentUser().id ?? "";
    }
    if(loading){
      return;
    }
    counter = 0;
    listPosts.clear();
    cachedTrainings.clear();

    loading = true;
    List<String> tmp = await getTrendingPostIdsByScore();
    listPosts.addAll(tmp);
    listPosts.where((id) => id != "default").toSet().toList();


    lastcounter = counter;

    setState(() {

    });

    for (int i = lastcounter; i < listPosts.length; i++) {
      String s = listPosts[counter];
      TrainingModel tmp = TrainingModel();

      if (CachedData().trainings.containsKey(s)) {
        tmp = CachedData().trainings[s]!;
      } else {
        await tmp.fetchExternalData(s);
        CachedData().trainings[s] = tmp;
      }
      setState(() {
        cachedTrainingsModels[counter] = tmp;
        counter++;
      });
    }
    setState(() {
      finished = true;
    });

    await loadTrainings();
  }

  Future<void> loadTrainings() async {
    for (int i = lastcounter; i < cachedTrainingsModels.length; i++) {
      if (!cachedTrainings.containsKey(i)) {setState(() {
          cachedTrainings[i] = TrainingCard(trn: cachedTrainingsModels[i]!,);
        });
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    pc.dispose();
    pcbis.dispose();
    super.dispose();
  }

  bool changefeed = false;
  bool feedfiends = true;
  bool feedtrend = false;
  bool feedfyp = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      body: PreloadPageView.builder(
        scrollDirection: Axis.horizontal,
        controller: pcbis,
        itemCount: 2,
        preloadPagesCount: 1,
        itemBuilder: (context, index) {
          return index == 0 ?

          Stack(
            clipBehavior: Clip.none,
            children: [
              if(counter == 0 && finished)
                Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/emoji_sablier.png", height: 28,),
                    const SizedBox(height: 15,),
                    DefaultTextStyle(
                      style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 15),
                      child: const Text("Tes amis n'ont encore rien posté"),
                    ),
                    const SizedBox(height: 3,),
                    DefaultTextStyle(
                      style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 15),
                      child: const Text("aujourd'hui, motive les un peu !"),
                    ),
                  ],
                ),)
              else if(counter > 0)
                PreloadPageView.builder(
                controller: pc,
                scrollDirection: Axis.vertical,
                itemCount: counter,
                preloadPagesCount: 3,
                itemBuilder: (context, index) {
                  return !cachedTrainings.containsKey(index)
                      ? Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
                    child: const LoadingTraining(),
                  )
                      : Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.11),
                    child: cachedTrainings[index],
                  );
                },
              )
              else
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
                  child: const LoadingTraining(),
                ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GlassContainer(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: const Color(0xFFF3F5F8).withOpacity(0.7),
                    blur: 10,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.07,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTapUp: (t) {
                              Haptics.vibrate(HapticsType.medium);
                              setState(() {
                                changefeed = true;
                              });
                            },
                            child: Row(
                              children: [
                                if(feedtrend)
                                  Text(
                                    "Tendances",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                if(feedfyp)
                                  Text(
                                    "Pour toi",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                if(feedfiends)
                                  Text(
                                    "Tes amis",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black.withOpacity(0.8),
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              /*
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: GestureDetector(
                                  onTapUp: (t) {
                                    pcbis.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: Colors.white54,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                      ],
                                    ),
                                  ),
                                ),
                              ),

                               */
                              const SizedBox(width: 15,),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: GestureDetector(
                                  onTapUp: (t) {
                                    pcbis.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedFavourite,
                                        color: Colors.black.withOpacity(0.7),
                                        size: 24.0,
                                      ),
                                      if(StoredNotification().tday)
                                        Positioned(
                                          top: 1,
                                          right: -1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                            width: 8,
                                            height: 8,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 170),
                                width: tdypostbool ? 70: 0,
                                height: 1,
                                curve: Curves.easeOut,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder<void>(
                    future: UserModel.currentUser().notificationsloader,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      } else if (snapshot.hasError) {
                        return const SizedBox();
                      } else if ((StoredNotification().nabo + StoredNotification().ncom + StoredNotification().nlike) == 0) {
                        return const SizedBox();
                      }

                      return AnimatedPositioned(
                          bottom: -25,
                          right: tdypostbool ? MediaQuery.of(context).size.width * 0.07 + 57 : MediaQuery.of(context).size.width * 0.07 - 12,
                          duration: const Duration(milliseconds: 160),
                          curve: Curves.easeOut,
                          child: Visibility(
                            visible: notifvisible,
                            child: Container(
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      top: -7,
                                      right: 3,
                                      child: Container(
                                        height: 24,
                                        width: 22,
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius: BorderRadius.circular(4)
                                        ),
                                        transform: Matrix4.rotationZ(3.14159 / 4),
                                      ),
                                    ),
                                    Container(
                                        height: 32,
                                        padding: const EdgeInsets.symmetric(horizontal: 13),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.redAccent,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if(StoredNotification().nlike != 0)
                                              Row(
                                                children: [
                                                  const Icon(CupertinoIcons.heart_fill, color: Colors.white, size: 14,),
                                                  const SizedBox(width: 3,),
                                                  Text(
                                                    StoredNotification().nlike < 10 ? StoredNotification().nlike.toString() : "9",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if(StoredNotification().nabo != 0)
                                              Padding(
                                                padding: EdgeInsets.only(left: StoredNotification().nlike != 0 ? 4: 0),
                                                child: Row(
                                                  children: [
                                                    const Icon(CupertinoIcons.person_solid, color: Colors.white, size: 14,),
                                                    const SizedBox(width: 3,),
                                                    Text(
                                                      StoredNotification().nabo < 10 ? StoredNotification().nabo.toString() : "9",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            if(StoredNotification().ncom != 0)
                                              Padding(
                                                padding: EdgeInsets.only(left: StoredNotification().nabo != 0 || StoredNotification().nlike != 0 ? 6 : 0),
                                                child: Row(
                                                  children: [
                                                    const Icon(CupertinoIcons.bubble_left_fill, color: Colors.white, size: 14,),
                                                    const SizedBox(width: 3,),
                                                    Text(
                                                      StoredNotification().ncom < 10 ? StoredNotification().ncom.toString() : "9",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      );
                    },
                  ),
                ],
              ),
              IgnorePointer(
                ignoring: !changefeed,
                child: AnimatedOpacity(
                    opacity: changefeed ? 1 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTapUp: (t){
                        setState(() {
                          changefeed = false;
                        });
                      },
                      child: GlassContainer(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: const Color(0xFFF3F5F8).withOpacity(0.5),
                        blur: 10,

                      ),
                    )
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedPositioned(
                      duration: const Duration(milliseconds: 600),
                      top: changefeed ? 200 : 50,
                      left: changefeed ? MediaQuery.of(context).size.width*0.2 : 40,
                      curve: Curves.easeOutExpo,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: changefeed ? 1.6 : 0,
                          curve: Curves.easeInOut,
                          child: GlassContainer(
                            color: Colors.black.withOpacity(0.5),
                            width: 110,
                            blur: 10,
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTapUp: (t){
                                      Haptics.vibrate(HapticsType.light);
                                      setState(() {
                                        feedfiends = true;
                                        feedfyp = false;
                                        feedtrend = false;
                                        changefeed = false;
                                        counter = 0;
                                        listPosts.clear();
                                        cachedTrainings.clear();
                                      });
                                      loadTrainingModels();
                                    },
                                    child: Container(
                                      width: 110,
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "Tes amis",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10,
                                                color: Colors.white.withOpacity(0.9),
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          HugeIcon(
                                            icon: HugeIcons.strokeRoundedUserMultiple02,
                                            color: Colors.white.withOpacity(0.9),
                                            size: 12,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 7,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                    child: Container(
                                      width: 300,
                                      height: 1,
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  const SizedBox(height: 7,),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTapUp: (t){
                                      Haptics.vibrate(HapticsType.light);
                                      setState(() {
                                        feedfiends = false;
                                        feedfyp = true;
                                        feedtrend = false;
                                        changefeed = false;
                                      });
                                    },
                                    child: Container(
                                      width: 110,
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "Pour toi",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10,
                                                color: Colors.white.withOpacity(0.9),
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          HugeIcon(
                                            icon: HugeIcons.strokeRoundedMagicWand03,
                                            color: Colors.white.withOpacity(0.9),
                                            size: 12,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 7,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                    child: Container(
                                      width: 300,
                                      height: 1,
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  const SizedBox(height: 7,),

                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTapUp: (t){
                                      Haptics.vibrate(HapticsType.light);
                                      setState(() {
                                        feedtrend = true;
                                        feedfiends = false;
                                        feedfyp = false;
                                        changefeed = false;
                                      });
                                      loadTrendings();
                                    },
                                    child: Container(
                                      width: 110,
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "Tendances",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10,
                                                color: Colors.white.withOpacity(0.9),
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          HugeIcon(
                                            icon: HugeIcons.strokeRoundedFire,
                                            color: Colors.white.withOpacity(0.9),
                                            size: 12,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              )
            ],
          )


              : NotificationPage(pg: pcbis,);
        },
      )
    );
  }
}

String getPostIdForToday(List<dynamic> posts) {
  DateTime today = DateTime.now();
  DateTime todayStart = DateTime(today.year, today.month, today.day);

  for (var post in posts) {
    if (post['timestamp'] is Timestamp) {
      DateTime postDate = (post['timestamp'] as Timestamp).toDate();

      if (postDate.isAfter(todayStart) && postDate.isBefore(todayStart.add(Duration(days: 1)))) {
        return post['training'];
      }
    }
  }

  return "none"; // Aucun post trouvé pour aujourd'hui
}
