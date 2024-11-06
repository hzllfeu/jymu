import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
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
import 'TrainingCard.dart';
import 'camera.dart';
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
  late final TabController tabController;
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


  @override
  void initState() {
    super.initState();
    pc = PreloadPageController();
    pcbis = PreloadPageController();
    pc.addListener(scrollListener);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.reset();
    _controller.forward();

    loadTrainingModels();
  }

  void scrollListener() {
    int index = pc.page!.toInt();
    if(index != _previousPage){
      setState(() {
        _previousPage = index;
      });

      if(index > counter - 2 && !loading && counter > 0){
        loadTrainingModels();
      }

    }
  }



  Future<void> loadTrainingModels() async {
    if(loading) {
      return;
    }
    loading = true;
    List<String> tmp = await getTrainingsForUser("", 3, listPosts);
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

      cachedTrainingsModels[counter] = tmp;
      counter++;
    }
    setState(() {

    });

    await loadTrainings();
  }

  Future<void> loadTrainings() async {
    for (int i = lastcounter; i < cachedTrainingsModels.length; i++) {
      if (!cachedTrainings.containsKey(i)) {setState(() {
          cachedTrainings[i] = TrainingCard(trn: cachedTrainingsModels[i]!, coverbool: false, coverimage: File(""),);
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
    tabController.dispose();
    super.dispose();
  }

  String _heroAddTodo = 'add-todo-hero';

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
              PreloadPageView.builder(
                controller: pc,
                scrollDirection: Axis.vertical,
                itemCount: counter,
                preloadPagesCount: 3,
                itemBuilder: (context, index) {
                  return !cachedTrainings.containsKey(index)
                      ? Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
                    child: const LoadingPost(),
                  )
                      : Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.11),
                    child: cachedTrainings[index],
                  );
                },
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GlassContainer(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Color(0xFFF3F5F8).withOpacity(0.7),
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
                            onTap: () {
                              Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                return Hero(
                                  tag: _heroAddTodo,
                                  createRectTween: (begin, end) {
                                    return CustomRectTween(begin: begin!, end: end!);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 100, right: 200, top: 100, bottom: 700),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: GlassContainer(
                                          width: 100,
                                          height: 100,
                                          blur: 10,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }));
                            },
                            child: Hero(
                              tag: _heroAddTodo,
                              createRectTween: (begin, end) {
                                return CustomRectTween(begin: begin!, end: end!);
                              },
                              child: Material(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    Text(
                                      "Pour vous",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black.withOpacity(0.8),
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5, right: 30),
                                child: GestureDetector(
                                  onTapUp: (t) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AllSettings(),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    CupertinoIcons.settings,
                                    color: Colors.black.withOpacity(0.6),
                                    size: 24,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: GestureDetector(
                                  onTapUp: (t) {
                                    pcbis.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.heart,
                                        color: Colors.black.withOpacity(0.7),
                                        size: 24,
                                        weight: 50,
                                      ),
                                      if(StoredNotification().tday)
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(40),

                                            ),
                                            child: Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius: BorderRadius.circular(40),
                                                ),
                                                width: 7,
                                                height: 7,
                                              ),
                                            ),
                                          )
                                        )
                                    ],
                                  ),
                                ),
                              ),
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
                        return SizedBox();
                      } else if (snapshot.hasError) {
                        return SizedBox();
                      } else if ((StoredNotification().nabo + StoredNotification().ncom + StoredNotification().nlike) == 0) {
                        return SizedBox();
                      }

                      return Positioned(
                          bottom: -25,
                          right: MediaQuery.of(context).size.width * 0.07 - 13,
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
                                      padding: EdgeInsets.symmetric(horizontal: 13),
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
                                                Icon(CupertinoIcons.heart_fill, color: Colors.white, size: 14,),
                                                SizedBox(width: 3,),
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
                                                  Icon(CupertinoIcons.person_solid, color: Colors.white, size: 14,),
                                                  SizedBox(width: 3,),
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
                                              padding: EdgeInsets.only(left: StoredNotification().nabo != 0 && StoredNotification().nlike != 0 ? 6 : 0),
                                              child: Row(
                                                children: [
                                                  Icon(CupertinoIcons.bubble_left_fill, color: Colors.white, size: 12,),
                                                  SizedBox(width: 3,),
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
                          )
                      );
                    },
                  ),
                ],
              ),
            ],
          )


              : NotificationPage(pg: pcbis,);
        },
      )
    );
  }
}
