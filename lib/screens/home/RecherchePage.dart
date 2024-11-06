import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/UserManager.dart';
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/home/LoadingLikes.dart';
import 'package:jymu/screens/home/LoadingPost.dart';
import 'package:jymu/screens/home/PostWidget.dart';
import 'package:jymu/screens/home/components/LikesComp.dart';
import 'package:jymu/screens/home/components/ModifyAccount.dart';

import 'package:jymu/screens/home/components/NotificationPage.dart';
import 'package:jymu/screens/home/components/PostCard.dart';
import 'package:jymu/screens/home/components/ProfileComp.dart';

import '../../Models/CachedData.dart';
import '../../Models/TrainingModel.dart';
import 'LoadingProfile.dart';
import 'TrainingLittle.dart';
import 'components/PostsComp.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class RecherchePage extends StatefulWidget {
  final String id;

  RecherchePage({super.key, required this.id});

  @override
  State<RecherchePage> createState() => _RecherchePageState();
}

class _RecherchePageState extends State<RecherchePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;
  Future<void>? _fetchDataFuture;

  Future<void>? data;
  List<String> listPosts = [];
  List<TrainingModel> listtrn = [];


  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      if(index != selectedIndex){
        selectedIndex = index;
        Haptics.vibrate(HapticsType.medium);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    data = loadTrainingModels();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> getProfileImageUrl(String uid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'user_profiles/$uid.jpg');
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      print('Erreur lors de la récupération de l\'image de profil : $e');
      return 'https://via.placeholder.com/150';
    }
  }

  Future<void> loadTrainingModels() async {
    List<String> tmp = await getTrainingsForUser("", 16, listPosts);
    listPosts.addAll(tmp);
    listPosts.where((id) => id != "default").toSet().toList();

    setState(() {

    });
    for (String s in listPosts) {
      TrainingModel tmp = TrainingModel();

      if (CachedData().trainings.containsKey(s)) {
        tmp = CachedData().trainings[s]!;
      } else {
        await tmp.fetchExternalData(s);
        CachedData().trainings[s] = tmp;
      }

      listtrn.add(tmp);
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F8),
      body: Stack(
        children: [
          FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator(radius: 14,),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur de chargement des trainings'));
              } else {
                return Padding(padding: EdgeInsets.symmetric(horizontal: 5),
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.205),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                            childAspectRatio: 0.7,
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final training = listtrn[index];
                              return TrainingLittle(trn: training);
                            },
                            childCount: listtrn.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          GlassContainer(
            height: MediaQuery.of(context).size.height*0.2,
            width: MediaQuery.of(context).size.width,
            color: Color(0xFFF3F5F8).withOpacity(0.85),
            blur: 10,
            child: Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.03, bottom: 0, left: MediaQuery.of(context).size.width*0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GlassContainer(
                    width: MediaQuery.of(context).size.width*0.85,
                    height: MediaQuery.of(context).size.height*0.05,
                    borderRadius: BorderRadius.circular(28),
                    color: Colors.white.withOpacity(0.8),
                    blur: 10,
                    shadowStrength: 3,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.search, size: 24, color: Colors.redAccent,),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.65,
                              child: CupertinoTextField(
                                cursorColor: Colors.redAccent,
                                placeholder: "N'importe quoi · Un profil · Un exercice",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.8)),
                                placeholderStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: CupertinoColors.systemGrey.withOpacity(0.6)),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    )
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          left: 60.0 * selectedIndex*1.47,
                          child: Container(
                            height: 3,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTabItem(
                              index: 0,
                              icon: CupertinoIcons.doc_text_search,
                              label: "Posts",
                            ),
                            _buildTabItem(
                              index: 1,
                              icon: CupertinoIcons.person,
                              label: "Profil",
                            ),
                            _buildTabItem(
                              index: 2,
                              icon: CupertinoIcons.text_bubble,
                              label: "Exos",
                            ),
                            _buildTabItem(
                              index: 3,
                              icon: CupertinoIcons.house,
                              label: "Salle",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildTabItem({required int index, required IconData icon, required String label}) {
    bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: isSelected ? 0.8 : 0.5,
              child: Icon(
                icon,
                size: 21,
                color: isSelected ? Colors.black.withOpacity(1) : Colors.black.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 2),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: isSelected ? 0.8 : 0.5,
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black.withOpacity(1) : Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget buildProfileContent(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(padding: EdgeInsets.symmetric(horizontal: 25),
            child: CupertinoSearchTextField(),
          ),
          const SizedBox(height: 1),
          Expanded(
            child: LoadingLikes(),
          ),
        ]
    );;
  }
}

