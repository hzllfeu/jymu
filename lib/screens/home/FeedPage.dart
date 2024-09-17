import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/PostManager.dart';
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/home/LoadingPost.dart';
import 'package:jymu/screens/home/PostWidget.dart';

import 'package:jymu/screens/home/components/NotificationPage.dart';
import 'package:jymu/screens/home/components/PostCard.dart';
import 'package:jymu/screens/home/components/ProfileComp.dart';
import 'package:jymu/screens/home/components/SelectPost.dart';
import 'package:jymu/screens/home/components/training_home.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

import 'TrainingCard.dart';
import 'camera.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class FeedPage extends StatefulWidget {
  FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {
  bool isFirstSelected = true;
  bool _isLoading = true;
  late final TabController tabController;
  List<String> cachedPosts = ["zt0xhMpU0ZZnNAqerWLF", "wdyTg8K4gOdMBZOyvpnh", "rHVIFO3rgcGjc3CtCfEc"];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _handleCallbackEvent(ScrollDirection direction, ScrollSuccess success,
      {int? currentIndex}) {
    print(
        "Scroll callback received with data: {direction: $direction, success: $success and index: ${currentIndex ?? 'not given'}}");
  }

  @override
  Widget build(BuildContext context) {

    final Controller controller = Controller();
    controller.addListener((event) {
    _handleCallbackEvent(event.direction, event.success);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      body: SafeArea(
        child: Stack(
          children: [
            TikTokStyleFullPageScroller(
              contentSize: cachedPosts.length,
              swipePositionThreshold: 0.2,
              swipeVelocityThreshold: 2000,
              animationDuration: const Duration(milliseconds: 400),
              controller: controller,
              builder: (BuildContext context, int index) {
                return TrainingCard(postID: cachedPosts[index]);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTapUp: (t) {
                          showCupertinoModalPopup(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.4),
                            builder: (BuildContext build) {
                              return TweenAnimationBuilder<double>(
                                duration: Duration(milliseconds: 300),
                                tween: Tween<double>(begin: 0.0, end: 4.0),
                                curve: Curves.linear,
                                builder: (context, value, _) {
                                  return AnimatedOpacity(
                                    duration: Duration(milliseconds: 1000),
                                    opacity: 1.0,
                                    curve: Curves.linear,
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: value, sigmaY: value),
                                      child: CupertinoPopupSurface(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          height: MediaQuery.of(context).size.height*0.7,
                                          child: ProfileComp(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 38,
                          width: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                              child: Image.asset('assets/images/emoji_settings.png', height: 24,)
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: PreferredSize(
                          preferredSize: const Size.fromHeight(40),
                          child: Stack(
                            children: [
                              Container(
                                height: 40,
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                  color: const Color(0xFFF3F5F8),
                                ),
                              ),
                              // Container pour le gradient
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(18)),
                                child: Container(
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color(0xffF14BA9).withOpacity(0.3),
                                        Colors.redAccent.withOpacity(0.3),
                                      ],
                                    ),
                                  ),
                                  child: TabBar(
                                    controller: tabController,
                                    onTap: (i) {
                                      setState(() {
                                        Haptics.vibrate(HapticsType.light);
                                      });
                                    },
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    dividerColor: Colors.transparent,
                                    indicator: const BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.all(Radius.circular(18)),
                                    ),
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.black54,
                                    tabs: const [
                                      Tab(text: 'For you'),
                                      Tab(text: 'Amis'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapUp: (t) async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsernamePage(),
                              ),
                            );
                          } catch (e) {
                            print('Failed to sign out: $e');
                          }
                        },
                        child: Container(
                          height: 38,
                          width: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                              child: Image.asset('assets/images/emoji_bell.png', height: 20,)
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.37, right: MediaQuery.of(context).size.width*0.37, bottom: 0),
                    width: 200,
                    height: MediaQuery.of(context).size.height*0.06,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
                      color: Color(0xFFF3F5F8),
                    ),
                  ),
                  GestureDetector(
                    onTapUp: (t) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraPage(),
                        ),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.37, right: MediaQuery.of(context).size.width*0.37, bottom: 0),
                        width: 200,
                        height: MediaQuery.of(context).size.height*0.06,
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Color(0xffF14BA9).withOpacity(0.7), Colors.redAccent.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 47,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                    child: Image.asset('assets/images/emoji_phone.png', height: 26,)
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
