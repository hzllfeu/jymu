import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jymu/PostManager.dart';
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/home/LoadingPost.dart';
import 'package:jymu/screens/home/PostWidget.dart';

import 'package:jymu/screens/home/components/NotificationPage.dart';
import 'package:jymu/screens/home/components/PostCard.dart';
import 'package:jymu/screens/home/components/ProfileComp.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class FeedPage extends StatefulWidget {
  FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool isFirstSelected = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F8),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
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
                                          height: 670,
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
                        child: Icon(
                          CupertinoIcons.settings,
                          size: 26,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: 5),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 50,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isFirstSelected = true;
                                        });
                                      },
                                      child: Text(
                                        "For you",
                                        style: TextStyle(
                                          color: isFirstSelected
                                              ? Colors.redAccent
                                              : CupertinoColors.systemGrey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isFirstSelected = false;
                                        });
                                      },
                                      child: Text(
                                        "Abonnés",
                                        style: TextStyle(
                                          color: isFirstSelected
                                              ? CupertinoColors.systemGrey
                                              : Colors.redAccent,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                AnimatedPositioned(
                                  duration: Duration(milliseconds: 150),
                                  curve: Curves.easeInOut,
                                  top: 43,
                                  left: isFirstSelected ? 45 : 140,
                                  child: Container(
                                    height: 3,
                                    width: 25,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                        child: Icon(
                          CupertinoIcons.bell,
                          size: 26,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                StreamBuilder<QuerySnapshot>(
                  stream: getPosts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              4, // Nombre d'éléments de chargement
                                  (index) => SizedBox(
                                height: 200,
                                child: Center(child: LoadingPost()),
                              ),
                            ),
                          ),
                        ),
                      );
                    }


                    if (!snapshot.hasData) {
                      return const Center(child: Text('Aucun post disponible.'));
                    }

                    final posts = snapshot.data!.docs;

                    return Expanded(
                      child: ListView.builder(
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
                      ),
                    );
                  },
                )
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
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
                                  height: 670,
                                  child: NewPostWidget(),
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
                    padding: EdgeInsets.all(15.0),
                    margin: EdgeInsets.only(left: 130, right: 130, bottom: 15),
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 12,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.photo_camera, color: Colors.redAccent, size: 22,),
                          SizedBox(width: 10,),
                          Text("Poster", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.7)),)
                        ],
                      ),
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
