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

const Color inActiveIconColor = Color(0xFFB6B6B6);

class FeedPage extends StatefulWidget {
  FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  bool isFirstSelected = true;
  bool _isLoading = true;
  late final TabController tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      body: SafeArea(
        child: Stack(
          children: [
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
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
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
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    height: 40,
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                                      enableFeedback: true,
                                      onTap: (i) {
                                        setState(() {
                                          Haptics.vibrate(HapticsType.light);
                                        });
                                      },
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      dividerColor: Colors.transparent,
                                      indicator: const BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  const SizedBox(height: 30),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: getPosts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
                          return SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                4, // Nombre d'éléments de chargement
                                    (index) => SizedBox(
                                  height: 200,
                                  child: Center(child: LoadingPost()),
                                ),
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(child: Text('Aucun post disponible.'));
                        }

                        final posts = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index].data() as Map<String, dynamic>;

                            return PostCard(
                              username: post['username'],
                              content: post['content'],
                              postTime: (post['postTime'] as Timestamp).toDate(),
                              userId: post['id'],
                              likes: post['likes'],
                              postID: posts[index].id,
                            );
                          },
                        );
                      },
                    ),
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
                                      height: MediaQuery.of(context).size.height*0.3,
                                      child: SelectPost(),
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
