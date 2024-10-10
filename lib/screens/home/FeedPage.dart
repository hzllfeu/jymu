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


  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    pc = PreloadPageController();
    pcbis = PreloadPageController();
    pc.addListener(scrollListener);

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
          cachedTrainings[i] = TrainingCard(trn: cachedTrainingsModels[i]!);
        });
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    pc.dispose();
    pcbis.dispose();
    tabController.dispose();
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
              GlassContainer(
                height: MediaQuery.of(context).size.height*0.12,
                color: Color(0xFFF3F5F8).withOpacity(0.7),
                blur: 10,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1, vertical: 10),
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
                                    )
                                ),
                              )
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                      color: Colors.black.withOpacity(0.8)
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Icon(Icons.keyboard_arrow_down, color: Colors.redAccent.withOpacity(0.8), size: 18,),
                              ],
                            ),
                          )
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5, right: 20),
                            child: GestureDetector(
                                onTapUp: (t){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllSettings(),
                                    ),
                                  );
                                },
                                child: Icon(CupertinoIcons.settings, color: Colors.black.withOpacity(0.6), size: 22,),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: GestureDetector(
                                onTapUp: (t){
                                  pcbis.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Icon(CupertinoIcons.bell, color: Colors.black.withOpacity(0.7), size: 22,),
                                    FutureBuilder<void>(
                                      future: UserModel.currentUser().notificationsloader,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return SizedBox();
                                        } else if (snapshot.hasError) {
                                          return SizedBox();
                                        } else if (StoredNotification().n == 0) {
                                          return SizedBox();
                                        }

                                        return Positioned(
                                          bottom: 0,
                                          right: -3,
                                          child: Container(
                                              height: 12.5,
                                              padding: EdgeInsets.symmetric(horizontal: 4),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(14),
                                                  color: Colors.redAccent
                                              ),
                                              child: Center(
                                                child: Text(
                                                  StoredNotification().n < 10 ? StoredNotification().n.toString(): "9+",
                                                  style: const TextStyle(
                                                      fontSize: 8.5,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white
                                                  ),
                                                ),
                                              )
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )


              : NotificationPage(pg: pcbis,);
        },
      )
    );
  }
}
