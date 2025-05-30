import 'dart:async';
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
import 'package:hugeicons/hugeicons.dart';
import 'package:jymu/Models/TrainingModel.dart';
import 'package:jymu/Models/UserModel.dart';
import 'package:jymu/UserManager.dart' as um;
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/home/LoadingLikes.dart';
import 'package:jymu/screens/home/LoadingPost.dart';
import 'package:jymu/screens/home/PostWidget.dart';
import 'package:jymu/screens/home/RechercheProfil.dart';
import 'package:jymu/screens/home/TrainingLittle.dart';
import 'package:jymu/screens/home/TrainingsProfile.dart';
import 'package:jymu/screens/home/components/LikesComp.dart';
import 'package:jymu/screens/home/components/ModifyAccount.dart';

import 'package:jymu/screens/home/components/NotificationPage.dart';
import 'package:jymu/screens/home/components/PostCard.dart';
import 'package:jymu/screens/home/components/ProfileComp.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../Models/CachedData.dart';
import '../Models/NotificationService.dart';
import 'InputPage.dart';
import 'home/LoadingProfile.dart';
import 'home/components/TagList.dart';
import 'home/settings/AllSettings.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class ProfilPageBis extends StatefulWidget {
  final String id;

  ProfilPageBis({super.key, required this.id});

  @override
  State<ProfilPageBis> createState() => _ProfilPageBisState();
}

class _ProfilPageBisState extends State<ProfilPageBis> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late AnimationController _controllernotif;
  late Animation<double> _scaleAnimationotif;
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
  List<dynamic>? followers;
  List<dynamic>? follow;
  List<dynamic>? likes;
  List<dynamic>? trainings;

  bool notifvisible = false;

  List<dynamic>? tags;
  bool ownProf = false;
  bool friendppempty = true;
  bool followppempty = true;
  bool followedppempty = true;

  late final TabController tabController;
  final GlobalKey _containerKey = GlobalKey();
  Size? _containerSize;
  Future<Widget>? _friendsPPFuture;
  Future<Widget>? _followedPPFuture;
  Future<Widget>? _followPPFuture;

  late UserModel ownUser;
  UserModel targetUser = UserModel();

  Color firstMainColor = Colors.transparent;
  Color secondMainColor = Colors.transparent;

  double contentHeight = 335;
  final GlobalKey _contentKey = GlobalKey();

  Future<void> _updatePalette() async {
    try {
      final ImageStream imageStream = Image.network(profileImageUrl!).image.resolve(ImageConfiguration.empty);

      final Completer<ImageInfo> completer = Completer<ImageInfo>();
      imageStream.addListener(ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
        completer.complete(imageInfo);
      }));

      final ImageInfo imageInfo = await completer.future;

      final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImage(imageInfo.image);

      firstMainColor = paletteGenerator.lightMutedColor?.color ?? Colors.transparent;
      secondMainColor = paletteGenerator.darkMutedColor?.color ?? Colors.transparent;

      setState(() {});

    } catch (e) {
      print("Erreur lors de la génération de la palette: $e");
    }
  }

  void _getContainerSize() {
    final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
    setState(() {
      _containerSize = renderBox.size;
    });
  }

  void _getFlexibleContentHeight() {
    final renderBox = _contentKey.currentContext?.findRenderObject();
    if (renderBox is RenderBox) {
      setState(() {
        print(renderBox.size.height);
        contentHeight = renderBox.size.height;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    tabController = TabController(length: 2, vsync: this);

    id = widget.id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getFlexibleContentHeight();
    });

    _fetchDataFuture = _fetchData(false);

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

    _controllernotif = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimationotif = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controllernotif, curve: Curves.easeInOut),
    );

    startAnim();
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
    await um.unfollowUser(FirebaseAuth.instance.currentUser!.uid, id!);
    setState(() {
      followed = false;
      friend = false;
      _controller.reset();
      _controller.forward();
    });
  }

  Future<void> startAnim() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      notifvisible = true;
    });
    _controllernotif.reset();
    _controllernotif.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    tabController.dispose();
    _controllernotif.dispose();
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


  Future<void> _fetchData(bool refresh) async {
    try {
      if (id != null) {
        if (id == FirebaseAuth.instance.currentUser?.uid) {
          setState(() {
            ownProf = true;
          });
        }
        if (!ownProf) {

          if(refresh){
            if(CachedData().users.containsKey(id!)){
              CachedData().users.remove(id!);
              CachedData().links.remove(id!);
            }
          }

          if(CachedData().users.containsKey(id!)){
            targetUser = CachedData().users[id!]!;
          } else {
            await targetUser.fetchExternalData(id!);
            CachedData().users[id!] = targetUser;
          }

          setState(() {

          });
        }
        await _fetchProfileImageUrl();
        await _updatePalette();
        if (!mounted) return;

        setState(() {


          followers = (ownProf ? UserModel.currentUser().followed : targetUser.followed)!;
          likes = (ownProf ? UserModel.currentUser().likes : targetUser.likes)!;
          username = (ownProf ? UserModel.currentUser().username : targetUser.username)!;
          displayName = (ownProf ? UserModel.currentUser().displayName : targetUser.displayName)!;
          follow = (ownProf ? UserModel.currentUser().follow : targetUser.follow)!;
          bio = (ownProf ? UserModel.currentUser().bio : targetUser.bio)!;
          tags = (ownProf ? UserModel.currentUser().tags : targetUser.tags)!;
          trainings = (ownProf ? UserModel.currentUser().trainings : targetUser.trainings)!;

          if (!ownProf && followers!.contains(FirebaseAuth.instance.currentUser?.uid)) {
            followed = true;
          }
          if (!ownProf && follow!.contains(FirebaseAuth.instance.currentUser?.uid)) {
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
      late String tmp;
      if(CachedData().links.containsKey(id!)){
        tmp = CachedData().links[id!]!;
      } else {
        tmp = await getProfileImageUrl(id!);
        CachedData().links[id!] = tmp;
      }

      if (!mounted) return;
      setState(() {
        profileImageUrl = tmp;
      });
    }
  }

  Future<Widget> getFriendspp() async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    List<String> friends = (ownProf ? UserModel.currentUser().followed : targetUser.followed)!
        .toSet()
        .intersection(UserModel.currentUser().follow!.toSet())
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

    for(String id in finalList){
      String tmp = "";
      if(CachedData().links.containsKey(id)){
        tmp = CachedData().links[id]!;
      } else {
        tmp = await getProfileImageUrl(id);
        CachedData().links[id] = tmp;
      }
      finalppList[id] = tmp;
    }

    if(finalList.isNotEmpty){
      setState(() {
        friendppempty = false;
      });
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

    finalList.addAll(followers!.take(4).cast());

    for(String id in finalList){
      String tmp = "";
      if(CachedData().links.containsKey(id)){
        tmp = CachedData().links[id]!;
      } else {
        tmp = await getProfileImageUrl(id);
        CachedData().links[id] = tmp;
      }
      finalppList[id] = tmp;
    }

    if(finalList.isNotEmpty){
      setState(() {
        followedppempty = false;
      });
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

    finalList.addAll(follow!.take(4).cast());

    for(String id in finalList){
      String tmp = "";
      if(CachedData().links.containsKey(id)){
        tmp = CachedData().links[id]!;
      } else {
        tmp = await getProfileImageUrl(id);
        CachedData().links[id] = tmp;
      }
      finalppList[id] = tmp;
    }

    if(finalList.isNotEmpty){
      setState(() {
        followppempty = false;
      });
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

  bool showpp = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      body: Stack(
        children: [
          FutureBuilder(
            future: _fetchDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator(radius: 14,),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erreur de chargement des trainings'));
              } else {
                return Padding(padding: const EdgeInsets.only(right: 8, left: 8, top: 0),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      CupertinoSliverRefreshControl(

                        onRefresh: () async {
                          _fetchDataFuture = _fetchData(true);
                        },
                        builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
                          final double indicatorHeight = -125.0; // Hauteur de l'indicateur
                          final double offset =
                              (pulledExtent - indicatorHeight) / 2 + 50;

                          return Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: offset),
                            child: const CupertinoActivityIndicator(),
                          );
                        },
                      ),
                      SliverToBoxAdapter(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 0, top: 125,),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTapUp: (t){
                                        setState(() {
                                          showpp = true;
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: CircleAvatar(
                                          radius: 42.0,
                                          backgroundImage: CachedNetworkImageProvider(profileImageUrl!),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.06),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                const Text(
                                                  "Posts",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 13,
                                                    color: CupertinoColors.systemGrey,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  formatNumber(trainings!.length),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 19,
                                                    color: Colors.black.withOpacity(0.8),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            GestureDetector(
                                              onTapUp: (t) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Scaffold(body: RechercheProfil(id: id, index: 1)),
                                                  ),
                                                );
                                                Haptics.vibrate(HapticsType.light);
                                              },
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Abonnés",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 13,
                                                      color: CupertinoColors.systemGrey,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    formatNumber(followers!.length),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 19,
                                                      color: Colors.black.withOpacity(0.8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            GestureDetector(
                                              onTapUp: (t) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Scaffold(body: RechercheProfil(id: id, index: 2)),
                                                  ),
                                                );
                                                Haptics.vibrate(HapticsType.light);
                                              },
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Suivis",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 13,
                                                      color: CupertinoColors.systemGrey,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    formatNumber(follow!.length),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 19,
                                                      color: Colors.black.withOpacity(0.8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              if(bio!.isNotEmpty)
                                const SizedBox(height: 10,),
                              if(bio!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(bio!, style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: 7*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                                        fontWeight: FontWeight.w600), textAlign: TextAlign.left,),
                                  ),
                                ),
                              if (tags?.isNotEmpty ?? false)
                                const SizedBox(height: 15,),
                              if (tags?.isNotEmpty ?? false)
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: SizedBox(
                                    height: 50,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Colors.black.withOpacity(0.00),  // Moins opaque au début (plus court à gauche)
                                              Colors.black.withOpacity(0.0),
                                              Colors.black.withOpacity(0.5),
                                              Colors.black.withOpacity(0.7),
                                              Colors.black.withOpacity(0.9),
                                              Colors.black,  // Opacité totale à droite
                                              Colors.transparent,  // Transparence totale à droite
                                            ],
                                            stops: const [0.0, 0.005, 0.03, 0.2, 0.5, 0.85, 1.0],
                                          ).createShader(bounds);
                                        },
                                        blendMode: BlendMode.dstIn,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: List.generate(
                                                tags?.length ?? 0,
                                                    (index) => getTag(tags![index] ?? "false", false, context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: GestureDetector(
                                    onTapUp: (t) async {
                                      if (ownProf) {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                              body: ModifyAccount(
                                                pp: profileImageUrl,
                                              ),
                                            ),
                                          ),
                                        );
                                        CachedData().links.remove(id!);
                                        CachedData().users.remove(id!);
                                        _fetchDataFuture = _fetchData(false);
                                      } else {
                                        if (!followed) {
                                          await um.followUser(FirebaseAuth.instance.currentUser!.uid, id!);
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
                                    child: Container(
                                      width: double.infinity,
                                      height: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(color: Colors.redAccent.withOpacity(0.9),width: 1.5,),
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Center(
                                        child: ownProf ? Text("Modifier", style: TextStyle(color: Colors.redAccent.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w600),)
                                            : followed ? Text("Ne plus suivre", style: TextStyle(color: Colors.redAccent.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w600),)
                                            : isFollowing ? Text("Suivre en retour", style: TextStyle(color: Colors.redAccent.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w600),) : Text("Suivre", style: TextStyle(color: Colors.redAccent.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w600),),
                                      ),
                                    ),
                                  )
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                height: 40,
                                width: double.infinity,
                                color: const Color(0xFFF3F5F8),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(7)),
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
                                        color: Colors.deepOrange,
                                        borderRadius: BorderRadius.all(Radius.circular(7)),
                                      ),
                                      labelColor: Colors.white,
                                      unselectedLabelColor: Colors.black54,
                                      tabs: [
                                        Tab(text: '${ownProf ? UserModel.currentUser().trainings?.length: targetUser.trainings?.length} Trainings'),
                                        Tab(text: '${ownProf ? UserModel.currentUser().posts?.length: targetUser.posts?.length} Posts'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              TrainingsProfile(user: ownProf ? UserModel.currentUser(): targetUser)
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                );
              }
            },
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              GlassContainer(
                height: 115,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFFF3F5F8).withOpacity(0.85),
                blur: 10,
                child: Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05, bottom: 10, left: MediaQuery.of(context).size.width*0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if(!ownProf)
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: GestureDetector(
                                onTapUp: (t) {
                                  if(!ownProf){
                                    Navigator.pop(context);
                                  }
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: !ownProf ? Colors.black.withOpacity(0.7) : Colors.transparent,
                                  size: 18,
                                )
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: FutureBuilder(
                                future: _fetchDataFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const SizedBox();
                                  } else if (snapshot.hasError) {
                                    return SizedBox();
                                  } else {
                                    return Text(
                                      "$username",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          color: Colors.black.withOpacity(0.7)
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 15,),
                            if (!ownProf && !friendppempty)
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
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
                                    height: 28,
                                    color: Colors.black.withOpacity(0.3),
                                    blur: 10,
                                    borderRadius: BorderRadius.circular(18),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Suivi(e) par   ",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
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
                              )
                            else if(friend)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0),
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
                                    height: 28,
                                    color: Colors.black.withOpacity(0.3),
                                    blur: 10,
                                    borderRadius: BorderRadius.circular(18),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Amis  ",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Icon(
                                            CupertinoIcons.person_solid,
                                            size: 13,
                                            color: Colors.white.withOpacity(0.8),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      if(ownProf)
                        Row(
                          children: [
                            const SizedBox(width: 10,),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedSquareUnlock02,
                              color: ownProf ? Colors.black.withOpacity(0.7) : Colors.transparent,
                              size: 16,
                            ),
                            const SizedBox(width: 7,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Text(
                                UserModel.currentUser().username!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    color: Colors.black.withOpacity(0.7)
                                ),
                              ),
                            ),
                            const SizedBox(width: 8,),
                            FutureBuilder(
                              future: _fetchDataFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox();
                                } else if (snapshot.hasError) {
                                  return const SizedBox();
                                } else {
                                  return Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrange,
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                  );
                                }
                              },
                            ),

                          ],
                        ),


                      Row(
                        children: [
                          if(ownProf)
                            Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: GestureDetector(
                                    onTapUp: (t) {
                                      if(!ownProf){
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NotificationPage(pg: PreloadPageController(initialPage: 30),),
                                          ),
                                        );
                                      }
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
                                    )
                                )
                            ),
                          if(ownProf)
                            const SizedBox(width: 30,),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: GestureDetector(
                              onTapUp: (t) {
                                if(!ownProf){
                                  _showActionSheet(context);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllSettings(),
                                    ),
                                  );
                                }
                              },
                              child: HugeIcon(
                                icon: ownProf ? HugeIcons.strokeRoundedAccountSetting03 : HugeIcons.strokeRoundedMoreHorizontal,
                                color: Colors.black.withOpacity(0.8),
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              if(ownProf)
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
                      right: MediaQuery.of(context).size.width * 0.07 + 30,
                      child: Visibility(
                        visible: notifvisible,
                        child: Container(
                          child: ScaleTransition(
                            scale: _scaleAnimationotif,
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
            ignoring: !showpp,
            child: AnimatedOpacity(
                opacity: showpp ? 1 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapUp: (t){
                    setState(() {
                      showpp = false;
                    });
                  },
                  child: GlassContainer(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.3),
                    blur: 15,

                  ),
                )
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            left: showpp ? MediaQuery.of(context).size.width*0.5 - 42 : 40,
            top: showpp ? 330 : 100,
            curve: Curves.easeOut,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: showpp ? 2 : 0,
              curve: Curves.easeOut,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 42.0,
                  backgroundImage: CachedNetworkImageProvider(profileImageUrl!),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Options'),
        actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputPage(text: "Raison du signalement", limit: 300),
                  ),
                );

                if (result != null) {
                  await targetUser.report(result.toString().trim());
                  Haptics.vibrate(HapticsType.light);
                }
              },
              child: const Text('Signaler'),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Annuler'),
        ),
      ),
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate{
  MyDelegate(this.tabBar);
  final Widget tabBar;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}
