import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/UserManager.dart';
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/home/LoadingLikes.dart';
import 'package:jymu/screens/home/LoadingPost.dart';
import 'package:jymu/screens/home/PostWidget.dart';
import 'package:jymu/screens/home/RechercheProfil.dart';
import 'package:jymu/screens/home/components/LikesComp.dart';
import 'package:jymu/screens/home/components/ModifyAccount.dart';

import 'package:jymu/screens/home/components/NotificationPage.dart';
import 'package:jymu/screens/home/components/PostCard.dart';
import 'package:jymu/screens/home/components/ProfileComp.dart';

import 'LoadingProfile.dart';
import 'components/PostsComp.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class ProfilPage extends StatefulWidget {
  final String id;

  ProfilPage({super.key, required this.id});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;
  Future<void>? _fetchDataFuture;


  bool isFirstSelected = true;
  bool isSecondSelected = false;
  bool isThirdSelected = false;
  bool _isLoading = true;
  User? user = FirebaseAuth.instance.currentUser;
  String? displayName;
  String? username;
  String? bio = "";
  String? id = "";
  String? profileImageUrl;
  bool followed = false;
  bool isFollowing = false;
  bool friend = false;
  late List<dynamic> followers;
  late List<dynamic> follow;
  late List<dynamic> likes;
  late Map<String, dynamic> data;
  late Map<String, dynamic> owndata;
  bool ownProf = false;

  late final TabController tabController;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    tabController = TabController(length: 3, vsync: this);

    id = widget.id;

    _fetchDataFuture = _fetchData();

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _colorAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  void handleFollow() {
    setState(() {
      followed = true;
      if (isFollowing) {
        friend = true;
      }
      _controller.reset();
      _controller.forward();
    });
  }

  Future<void> handleUnFollow() async {
    await unfollowUser(FirebaseAuth.instance.currentUser!.uid, id!);
    setState(() {
      followed = false;
      friend = false;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatNumber(int number) {
    if (number < 10000) {
      return number.toString();
    } else if (number < 1000000) {
      return (number / 1000).toStringAsFixed(0) + 'k';
    } else {
      return (number / 1000000).toStringAsFixed(0) + 'M';
    }
  }


  Future<void> _fetchData() async {
    try {
      if (id != null) {
        if (id == FirebaseAuth.instance.currentUser?.uid) {
          ownProf = true;
        }
        data = (await getProfile(id!))!;
        if (!ownProf) {
          owndata = (await getProfile(FirebaseAuth.instance.currentUser!.uid))!;
        }

        if (!mounted) return;  // Vérifiez si le widget est monté

        setState(() {
          _fetchProfileImageUrl();
          followers = data['followed'];
          likes = data['likes'];
          username = data['username'];
          displayName = data['displayname'];
          follow = data['follow'];
          bio = data['bio'];

          if (!ownProf && followers.contains(FirebaseAuth.instance.currentUser?.uid)) {
            followed = true;
          }
          if (!ownProf && follow.contains(FirebaseAuth.instance.currentUser?.uid)) {
            isFollowing = true;
          }
          if (!ownProf && followed && isFollowing) {
            friend = true;
          }

          if (!ownProf) {

            if (isFollowing) {
              _controller.forward();
            }
            if (friend) {
              _controller.forward();
            }
          }
        });
      }
    } catch (e) {
      print('Error in _fetchData: $e');
    }
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

  Future<void> _fetchProfileImageUrl() async {
    if (id != "") {
      String tmp = await getProfileImageUrl(id!);

      if (!mounted) return;
      setState(() {
        profileImageUrl = tmp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F8),
      body: SafeArea(
        child: FutureBuilder(
          future: _fetchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    if(!ownProf)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTapUp: (t) {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                CupertinoIcons.arrow_left,
                                size: 26,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 30),
                    LoadingProfile(),
                  ]
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur de chargement du profil'));
            } else {
              return buildProfileContent(context);
            }
          },
        ),
      ),
    );
  }

  Widget buildProfileContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if(!ownProf)
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
          if (!ownProf)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTapUp: (t) {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      CupertinoIcons.arrow_left,
                      size: 26,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  GestureDetector(
                    onTapUp: (t) {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
                          title: Text('$username'),
                          actions: <CupertinoActionSheetAction>[
                            CupertinoActionSheetAction(
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Signaler'),
                            ),
                            CupertinoActionSheetAction(
                              isDestructiveAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Annuler'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(
                      Icons.more_vert_sharp,
                      size: 26,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
          if(ownProf)
            SizedBox(height: MediaQuery.of(context).size.width*0.03),
          if(!ownProf)
            SizedBox(height: MediaQuery.of(context).size.width*0.04),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: ownProf ? MediaQuery.of(context).size.height*0.25 : MediaQuery.of(context).size.height*0.26,
                  padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xffF14BA9), Colors.redAccent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffF14BA9).withOpacity(0.5),
                        spreadRadius: 6,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Image Container
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.redAccent,
                            width: 0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              profileImageUrl ?? 'https://via.placeholder.com/150',
                            ),
                          ),
                        ),
                      ),
                      // Text Column
                      Column(
                        children: [
                          DefaultTextStyle(
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 26),
                            child: Text(displayName ?? ''),
                          ),
                          const SizedBox(height: 2),
                          DefaultTextStyle(
                            style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w700, fontSize: 14),
                            child: Text("@$username"),
                          ),
                        ],
                      ),
                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          if (followed && !ownProf)
                            GestureDetector(
                              onTapUp: (t) async {

                                showCupertinoDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                    title: const Text('Ne plus suivre'),
                                    content: Text('Es-tu sûr de ne plus vouloir suivre $username ?'),
                                    actions: <CupertinoDialogAction>[
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Non'),
                                      ),
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                          handleUnFollow();
                                        },
                                        child: const Text('Oui'),
                                      ),
                                    ],
                                  ),
                                );


                              },
                              child: Container(
                                  width: 130,
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: DefaultTextStyle(
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
                                      child: Text(
                                        "Ne plus suivre",
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          if (!followed && !ownProf)
                            GestureDetector(
                              onTapUp: (t) async {
                                await followUser(FirebaseAuth.instance.currentUser!.uid, id!);
                                handleFollow();
                              },
                              child: Container(
                                width: 95,
                                height: 30,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    DefaultTextStyle(
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
                                      child: Text(
                                        "Suivre",
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.plus,
                                      size: 19,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: -10,
                  left: 20,
                    child: GestureDetector(
                        onTapUp: (t) async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(body: RechercheProfil(id: id,),),
                            ),
                          );
                        },
                        child: IntrinsicWidth(
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.symmetric(horizontal: 13),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DefaultTextStyle(
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  child: Text(
                                    formatNumber(followers.length),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  CupertinoIcons.person_fill,
                                  size: 17,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ),

                if (ownProf)
                  Positioned(
                    top: 15,
                    right: 18,
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
                                    filter: ImageFilter.blur(sigmaX: value, sigmaY: value),
                                    child: CupertinoPopupSurface(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: 620,
                                        child: ModifyAccount(pp: profileImageUrl, data: data),
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
                        CupertinoIcons.pen,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                if(ownProf)
                  Positioned(
                    bottom: -10,
                    right: 20,
                    child: Container(
                      height: 30,
                      width: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                          child: Image.asset("assets/images/emoji_fire.png", height: 20,)
                      ),
                    ),
                  ),
                if(!ownProf)
                  Positioned(
                    bottom: -10,
                    right: 55,
                    child: Container(
                      height: 30,
                      width: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset("assets/images/emoji_fire.png", height: 20,)
                      ),
                    ),
                  ),
                if(isFollowing) //TODO anim deplacement des badges quand abonnement: badge ami de base: 20 => 10
                  Positioned(
                    bottom: -10,
                    right: 10,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Container(
                          height: 30,
                          width: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white.withOpacity(_colorAnimation.value),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Center(
                              child: Icon(
                                !friend ? CupertinoIcons.person_add_solid : CupertinoIcons.person_2_fill,
                                size: 18,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04),
            child: Text(bio!, style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 5*MediaQuery.of(context).size.width*0.007,
                fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
          PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xffF14BA9).withOpacity(0.3), Colors.redAccent.withOpacity(0.3)],
                  ),
                ),
                child: TabBar(
                  controller: tabController,
                  enableFeedback: true,
                  onTap: (i) {
                    setState(() {
                        isFirstSelected = i == 0;
                        isSecondSelected = i == 1;
                        isThirdSelected = i == 2;
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
                  tabs: [
                    Tab(text: 'Trainings'),
                    Tab(text: 'Posts'),
                    Tab(text: 'Likes'),
                  ],
                ),
              ),
            ),
          ),

          if(isFirstSelected)
            Expanded(
              child: LoadingLikes(),
            ),
          if(isSecondSelected)
            Expanded(
              child: LoadingLikes(),
            ),
          if(isThirdSelected)
            Expanded(
              child: LikeComp(likes: likes),
            ),
        ],
      ),
    );
  }
}

