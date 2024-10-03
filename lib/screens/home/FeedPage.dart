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
import 'package:preload_page_view/preload_page_view.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

import '../../Models/CachedData.dart';
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
  late final TabController tabController;
  List<String> listPosts = [];
  List<String> LoadedPosts = [];
  final Map<int, TrainingCard> cachedTrainings = {};
  final Map<int, TrainingModel> cachedTrainingsModels = {};
  int counter = 0;
  int lastcounter = 0;
  late PreloadPageController pc;
  bool loading = false;
  int _previousPage = 0;


  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    pc = PreloadPageController();
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
      if (!cachedTrainings.containsKey(i)) {
        setState(() {
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
    tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      body: Stack(
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.07,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTapUp: (t) {
                        /*showCupertinoModalPopup(
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
                        );*/
                      },
                      child: GlassContainer(
                        height: 38,
                        width: 42,
                        color: Colors.white54.withOpacity(0),
                        borderRadius: BorderRadius.circular(14),
                        blur: 0,
                        child: Center(
                            child: Image.asset('assets/images/emoji_settings.png', height: 0,)
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: PreferredSize(
                        preferredSize: const Size.fromHeight(40),
                        child:
                        ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(18)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: GlassContainer(
                                height: 40,
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.white54.withOpacity(0.4),
                                blur: 5,
                                child: TabBar(
                                  controller: tabController,
                                  onTap: (i) {
                                    setState(() {
                                      Haptics.vibrate(HapticsType.light);
                                    });
                                  },
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  dividerColor: Colors.transparent,
                                  indicatorColor: Colors.transparent,
                                  indicator: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.8),
                                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                                  ),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.black54,
                                  tabs: const [
                                    Tab(text: 'For you'),
                                    Tab(text: 'Amis'),
                                  ],
                                ),
                              ),
                            )
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
                      child: GlassContainer(
                        height: 40,
                        width: 42,
                        color: Colors.white54.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(14),
                        blur: 5,
                        shadowStrength: 6,
                        child: Center(
                            child: Image.asset('assets/images/emoji_bell.png', height: 18,)
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
