import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
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
import 'package:jymu/screens/home/RechercheProfil.dart';
import 'package:jymu/screens/home/components/LikesComp.dart';
import 'package:jymu/screens/home/components/ModifyAccount.dart';

import 'package:jymu/screens/home/components/NotificationPage.dart';
import 'package:jymu/screens/home/components/PostCard.dart';
import 'package:jymu/screens/home/components/ProfileComp.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'LoadingProfile.dart';
import 'components/PostsComp.dart';
import 'components/TagList.dart';

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
  late List<dynamic> tags;
  late Map<String, dynamic> data;
  late Map<String, dynamic> owndata;
  bool ownProf = false;
  bool friendppempty = true;

  late final TabController tabController;
  final GlobalKey _containerKey = GlobalKey();
  Size? _containerSize;
  Future<Widget>? _friendsPPFuture;
  Future<Widget>? _followedPPFuture;
  Future<Widget>? _followPPFuture;

  void _getContainerSize() {
    final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
    setState(() {
      _containerSize = renderBox.size;
    });
  }

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
    tabController.dispose();
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

        if (!mounted) return;

        setState(() {
          _fetchProfileImageUrl();
          followers = data['followed'];
          likes = data['likes'];
          username = data['username'];
          displayName = data['displayname'];
          follow = data['follow'];
          bio = data['bio'];
          tags = data['tags'];

          if (!ownProf && followers.contains(FirebaseAuth.instance.currentUser?.uid)) {
            followed = true;
          }
          if (!ownProf && follow.contains(FirebaseAuth.instance.currentUser?.uid)) {
            isFollowing = true;
          }
          if (!ownProf && followed && isFollowing) {
            friend = true;
          }

          if(!ownProf){
            _friendsPPFuture = getFriendspp();
          }

          _followedPPFuture = getFollowedspp();
          _followPPFuture = getFollowspp();

          _getContainerSize();

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

  Future<Widget> getFriendspp() async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    List<String> friends = data['followed']
        .toSet()
        .intersection(owndata['follow'].toSet())
        .where((id) => id != currentUserId)
        .toList()
        .cast<String>();

    List<String> finalList = [];
    Map<String, String> finalppList = {};

    finalList.addAll(friends.take(2));

    int excludedCount = friends.length- finalList.length;

    if(excludedCount == 0 && finalList.isNotEmpty){
      excludedCount = 1;
    }
    if(finalList.isNotEmpty){
      setState(() {
        friendppempty = false;
      });
    }

    for(String id in finalList){
      String tmp = await getProfileImageUrl(id);
      finalppList[id] = tmp;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...finalList.map((id) => Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                finalppList[id] ?? 'https://via.placeholder.com/150',
              ),
            ),
          ),
        ),
        ),


        if (excludedCount > 0)
          Container(
            height: 18,
            width: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
                child: Text(excludedCount > 9 ? "+9" : "+$excludedCount", style: TextStyle(color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.w800, fontSize: 10),)
            ),
          ),
      ],
    );
  }

  Future<Widget> getFollowedspp() async {
    List<String> finalList = [];
    Map<String, String> finalppList = {};

    finalList.addAll(followers.take(4).cast());

    for(String id in finalList){
      String tmp = await getProfileImageUrl(id);
      finalppList[id] = tmp;
    }

    return Row(
      children: [
        ...finalList.map((id) => Container(
          width: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
          height: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                finalppList[id] ?? 'https://via.placeholder.com/150',
              ),
            ),
          ),
        ),
        ),

      ],
    );
  }

  Future<Widget> getFollowspp() async {
    List<String> finalList = [];
    Map<String, String> finalppList = {};

    finalList.addAll(follow.take(4).cast());

    for(String id in finalList){
      String tmp = await getProfileImageUrl(id);
      finalppList[id] = tmp;
    }

    return Row(
      children: [
        ...finalList.map((id) => Container(
          width: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
          height: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                finalppList[id] ?? 'https://via.placeholder.com/150',
              ),
            ),
          ),
        ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F8),
      body: FutureBuilder(
          future: _fetchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              _controller.forward();
              return buildPage(context);
            }
          },
        ),
    );
  }

  Widget buildPage(BuildContext context){
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      profileImageUrl ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: profileImageUrl ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => FadeShimmer(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    highlightColor: Colors.grey.shade200,
                    baseColor: Colors.grey.shade300,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),

            if (!ownProf)
              Positioned(
                top: 70,
                left: 15,
                child: GestureDetector(
                  onTapUp: (t) {
                    Navigator.pop(context);
                  },
                  child: GlassContainer(
                    height: 38,
                    width: 43,
                    blur: 8,
                    shadowStrength: 5,
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.arrow_left,
                        size: 22,
                        color: CupertinoColors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),

            if (!ownProf && !friendppempty)
              Positioned(
                top: 70,
                right: 15,
                child: GestureDetector(
                  onTapUp: (t) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          body: RechercheProfil(id: id, index: 0),
                        ),
                      ),
                    );
                    Haptics.vibrate(HapticsType.light);
                  },
                  child: GlassContainer(
                    height: 38,
                    blur: 16,
                    border: Border.fromBorderSide(BorderSide.none),
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(18),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Suivi(e) par   ",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          FutureBuilder<Widget>(
                            future: _friendsPPFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CupertinoActivityIndicator(radius: 8);
                              } else if (snapshot.hasError) {
                                return Text('Erreur : ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                return GestureDetector(
                                  onTapUp: (t) {
                                  },
                                  child: snapshot.data!,
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),


            Positioned(
              top: MediaQuery.of(context).size.height / 2.5 - 50,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height / 1.5 + 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F5F8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28.0),
                    topRight: Radius.circular(28.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      spreadRadius: 10,
                      blurRadius: 15,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 1.5,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 150,
                                      ),
                                      child: DefaultTextStyle(
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.7),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        child: AutoSizeText(
                                          displayName ?? '',
                                          maxLines: 1,
                                          minFontSize: 11,
                                          style: TextStyle(
                                            fontSize: 5 * MediaQuery.of(context).size.width * 0.013,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 150,
                                      ),
                                      child: DefaultTextStyle(
                                        style: TextStyle(
                                          color: Colors.deepOrange.withOpacity(0.6),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        child: AutoSizeText(
                                          "@$username",
                                          maxLines: 1,
                                          minFontSize: 11,
                                          style: TextStyle(
                                            fontSize: 5 * MediaQuery.of(context).size.width * 0.008,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(  // Utilisation de Flexible pour que le bouton s'ajuste à l'espace disponible
                                child: GestureDetector(
                                  onTapUp: (t) async {
                                    if (ownProf) {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Scaffold(
                                            body: ModifyAccount(
                                              pp: profileImageUrl,
                                              data: data,
                                            ),
                                          ),
                                        ),
                                      );
                                      _fetchDataFuture = _fetchData();
                                    } else {
                                      if (!followed) {
                                        await followUser(FirebaseAuth.instance.currentUser!.uid, id!);
                                        handleFollow();
                                        Haptics.vibrate(HapticsType.success);
                                      } else {
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
                                        Haptics.vibrate(HapticsType.success);
                                      }
                                    }
                                  },
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,  // Permet de redimensionner le contenu si nécessaire
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      height: 25 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.redAccent,
                                            Colors.redAccent,
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.redAccent.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 120,  // Limite la taille maximale du texte dans le bouton
                                            ),
                                            child: DefaultTextStyle(
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                                                fontWeight: FontWeight.w700,
                                              ),
                                              child: AutoSizeText(
                                                ownProf ? "Modifier" : followed ? "ne plus suivre" : "Suivre",
                                                maxLines: 1,
                                                minFontSize: 12,
                                                style: TextStyle(fontSize: 7 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          if(ownProf)
                                          const SizedBox(width: 10),
                                          if(isFollowing)
                                            const SizedBox(width: 10),
                                          if (ownProf)
                                            Container(
                                              height: 12*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                                              width: 12*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width) + 5,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(14),
                                                color: Colors.white.withOpacity(0.2),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white.withOpacity(0.05),
                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  "assets/images/emoji_pencil.png",
                                                  height: 8*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                                                ),
                                              ),
                                            ),
                                          if (!ownProf && isFollowing)
                                            AnimatedBuilder(
                                              animation: _controller,
                                              builder: (context, child) {
                                                return Container(
                                                  height: 12*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                                                  width: 12*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width) + 5,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(14),
                                                    color: Colors.white.withOpacity(_colorAnimation.value),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.2),
                                                        spreadRadius: 2,
                                                        blurRadius: 3,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Transform.scale(
                                                    scale: _scaleAnimation.value,
                                                    child: Center(
                                                      child: Icon(
                                                        !friend ? CupertinoIcons.person_add_solid : CupertinoIcons.person_2_fill,
                                                        size: 7*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                                                        color: Colors.black.withOpacity(0.7),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        if(bio!.isNotEmpty)
                          SizedBox(height: MediaQuery.of(context).size.height*0.03,),

                        if(bio!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.0 + 3),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(bio!, style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 7*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                                  fontWeight: FontWeight.w600), textAlign: TextAlign.left,),
                            ),
                          ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.02,),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                      height: 80,
                                      padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<Widget>(
                                            future: _followedPPFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return CupertinoActivityIndicator(radius: 8,);
                                              } else if (snapshot.hasError) {
                                                return Text('Erreur : ${snapshot.error}');
                                              } else if (snapshot.hasData) {
                                                return snapshot.data!;
                                              } else {
                                                return Row();
                                              }
                                            },
                                          ),
                                          Row(
                                            children: [
                                              Text(formatNumber(followers.length), style: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w700, fontSize: 14),),
                                              Text(" Abonnés", style: TextStyle(color: CupertinoColors.systemGrey, fontWeight: FontWeight.w600, fontSize: 14),),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                    onTapUp: (t){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Scaffold(body: RechercheProfil(id: id, index: 1),),
                                        ),
                                      );
                                      Haptics.vibrate(HapticsType.light);

                                    },
                                  )
                              ),
                              SizedBox(width: 12,),
                              Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                      height: 80,
                                      padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<Widget>(
                                            future: _followPPFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return CupertinoActivityIndicator(radius: 8,);
                                              } else if (snapshot.hasError) {
                                                return Text('Erreur : ${snapshot.error}');
                                              } else if (snapshot.hasData) {
                                                return snapshot.data!;
                                              } else {
                                                return Row();
                                              }
                                            },
                                          ),
                                          Row(
                                            children: [
                                              Text(formatNumber(follow.length), style: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w700, fontSize: 14),),
                                              Text(" Abonnements", style: TextStyle(color: CupertinoColors.systemGrey, fontWeight: FontWeight.w600, fontSize: 14),),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    onTapUp: (t){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Scaffold(body: RechercheProfil(id: id, index: 2),),
                                        ),
                                      );
                                      Haptics.vibrate(HapticsType.light);

                                    },
                                  )
                              ),

                            ],
                          ),
                        ),


                        SizedBox(height: MediaQuery.of(context).size.height*0.015,),
                        if(tags.isNotEmpty)
                          SizedBox(
                            height: 40,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                      tags.length,
                                      (index) => index == 0 ? Row(children: [SizedBox(width: 0,),getTag(tags[index], false)],) : getTag(tags[index], false)
                                )
                              ),
                            ),
                          ),

                        SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.0),
                          child: PreferredSize(
                            preferredSize: const Size.fromHeight(40),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.redAccent.withOpacity(0.3),
                                      Colors.deepOrange.withOpacity(0.3),
                                    ],
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
                                    Tab(text: '0 Trainings'),
                                    Tab(text: '0 Posts'),
                                    Tab(text: '${likes.length} Likes'),
                                  ],
                                ),
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
                            child: LoadingLikes()
                          ),

                        if(isThirdSelected)
                          Expanded(
                            child: LikeComp(likes: likes),
                          ),
                      ],
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

