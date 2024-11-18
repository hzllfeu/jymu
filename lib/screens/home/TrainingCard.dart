import 'dart:io';
import 'dart:ui';

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/Models/CachedData.dart';
import 'package:jymu/Models/TrainingModel.dart';
import 'package:jymu/Models/UserModel.dart';
import 'package:jymu/PostManager.dart';
import 'package:jymu/screens/home/LoadingTraining.dart';
import 'package:jymu/screens/home/components/CommentPage.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

import '../InputPage.dart';
import '../ProfilPageBis.dart';
import 'components/TagList.dart';

class TrainingCard extends StatefulWidget {
  final TrainingModel trn;

  TrainingCard({
    required this.trn,
  });

  @override
  _TrainingCardState createState() => _TrainingCardState();
}

class _TrainingCardState extends State<TrainingCard> with TickerProviderStateMixin{
  bool liked = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;
  late Animation<double> _marginAnimation;
  late File fistImage;
  late File secondImage;
  bool firstTaken = false;
  bool secondTaken = false;
  bool showFirstImage = true;
  bool friendppempty = true;

  bool coverbool = false;

  Future<Widget>? _friendsPPFuture;

  Color firstMainColor = Colors.transparent;
  Color secondMainColor = Colors.transparent;
  Color tempMainColor = Colors.transparent;

  TrainingModel training = TrainingModel();
  UserModel targetUser = UserModel();
  Future<void>? fetchPostData;

  late AnimationController _animationController;
  late Animation<Offset> _animation;
  String pp = "";
  bool loaded = false;


  Future<void> _updatePalette(bool b) async {
    if(b == false){
      final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image.file(fistImage).image,
      );

      firstMainColor = paletteGenerator.dominantColor?.color ?? Colors.transparent;
    } else {
      final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image.file(secondImage).image,
      );

      secondMainColor = paletteGenerator.dominantColor?.color ?? Colors.transparent;
    }
  }

  String formatNumber(int number) {
    if (number < 10000) {
      return number.toString();
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(0)}k';
    } else {
      return '${(number / 1000000).toStringAsFixed(0)}M';
    }
  }

  Future<Widget> getFriendspp() async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    List<String> friends = (targetUser.followed)!
        .toSet()
        .intersection(training.likes!.toSet())
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
          width: 18,
          height: 18,
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
            height: 16,
            width: 20,
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

  Future<void> getPostData() async {

    if(CachedData().users.containsKey(training.userId!)){
      targetUser = CachedData().users[training.userId!]!;
    } else {
      await targetUser.fetchExternalData(training.userId!);
      CachedData().users[training.userId!] = targetUser;
    }
    if(CachedData().images.containsKey(training.firstImage!)){
      fistImage = CachedData().images[training.firstImage!]!;
    } else {
      fistImage = (await getImage(training.firstImage!))!;
      CachedData().images[training.firstImage!] = fistImage;
    }
    if(CachedData().images.containsKey(training.secondImage!)){
      secondImage = CachedData().images[training.secondImage!]!;
    } else {
      secondImage = (await getImage(training.secondImage!))!;
      CachedData().images[training.secondImage!] = secondImage;
    }

    _friendsPPFuture = getFriendspp();

    if(CachedData().links.containsKey(targetUser.id!)){
      pp = CachedData().links[targetUser.id!]!;
    } else {
      pp = await getProfileImageUrl(targetUser.id!);
      CachedData().links[targetUser.id!] = pp;
    }


    loaded = true;

    if(training.likes!.contains(UserModel.currentUser().id)){
      liked = true;
    }

    if(mounted){
      setState(() {

      });
    }

    return;

    _updatePalette(true);
    _updatePalette(false);
  }

  @override
  void initState() {
    super.initState();

    training = widget.trn;
    fetchPostData = getPostData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.04))
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationController);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _colorAnimation = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _controller.reset();
    _controller.forward();

  }

  Future<void> cover() async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      coverbool = false;
    });
  }

  Future<void> _handleTap() async {
    setState(() {
      liked = !liked;
      if (liked) {
         training.addLike();
        _controller.forward();
        Haptics.vibrate(HapticsType.medium);
        CachedData().trainings[training.id]?.likes?.add(UserModel.currentUser().id);
      } else {
         training.removeLike();
        _controller.reverse();
         CachedData().trainings[training.id]?.likes?.remove(UserModel.currentUser().id);
      }
    });
  }

  Future<String> getProfileImageUrl(String uid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('user_profiles/$uid.jpg');
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      print('Erreur lors de la récupération de l\'image de profil : $e');
      return 'https://via.placeholder.com/150';
    }
  }

  Future<File?> getImage(String imagePath) async {
    try {
      String downloadUrl = await FirebaseStorage.instance.ref().child('images/$imagePath').getDownloadURL();

      var response = await http.get(Uri.parse(downloadUrl));

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      File file = File('$tempPath/${imagePath.split('/').last}');

      await file.writeAsBytes(response.bodyBytes);

      return file;
    } catch (e) {
      print('Erreur lors du téléchargement du fichier: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _checkAndAnimate() {
      _animationController.forward().then((_) => _animationController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.9,
      color: Colors.transparent,
      child: Column(
        children: [
          if(!loaded)
            SizedBox(height: size.height*0.01)
          else
            SizedBox(height: size.height*0.01),
          if(loaded)
            SizedBox(
              height: size.height*0.55,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 10,
                    child: Container(
                      width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color(0xffff5d5d),
                        boxShadow: [ BoxShadow(
                          color: !showFirstImage ? firstMainColor.withOpacity(0.3) : showFirstImage ? secondMainColor.withOpacity(0.3) : Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, -1),
                        ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image(
                              image: showFirstImage ? Image.file(secondImage).image : Image.file(fistImage).image,
                              fit: BoxFit.cover,
                            ).blur(blur: 3)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    child: SlideTransition(
                        position: _animation,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 40,
                              height: MediaQuery.of(context).size.height * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.redAccent.withOpacity(1),
                                    Colors.deepOrange.withOpacity(1),
                                  ],
                                ),
                                boxShadow: [ BoxShadow(
                                  color: showFirstImage ? firstMainColor.withOpacity(0.5) : !showFirstImage ? secondMainColor.withOpacity(0.5) : Colors.black.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.5,
                                      width: MediaQuery.of(context).size.width - 40,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        clipBehavior: Clip.none,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            fit: StackFit.expand,
                                            children: [
                                              Listener(
                                                onPointerUp: (event) {
                                                  setState(() {
                                                    showFirstImage = !showFirstImage;
                                                  });
                                                  HapticFeedback.lightImpact();
                                                  _checkAndAnimate();
                                                },
                                                child: Image.file(showFirstImage ? fistImage : secondImage, fit: BoxFit.cover),
                                              ),
                                              Positioned(
                                                  bottom: 10,
                                                  child: SizedBox(
                                                    width: MediaQuery.of(context).size.width - 60,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTapUp: (t){
                                                            if(training.userId != FirebaseAuth.instance.currentUser?.uid) {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ProfilPageBis(id: training.userId!),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          child: Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 26.0,
                                                                backgroundImage: CachedNetworkImageProvider(pp),
                                                              ),
                                                              const SizedBox(width: 5,),
                                                              ConstrainedBox(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: size.width*0.25
                                                                ),
                                                                child: GlassContainer(
                                                                  height: 50,
                                                                  color: Colors.black.withOpacity(0.5),
                                                                  blur: 10,
                                                                  borderRadius: BorderRadius.circular(18),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        FittedBox(
                                                                          fit: BoxFit.scaleDown,
                                                                          child: Text(
                                                                            targetUser.displayName!,
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 13,
                                                                              color: Colors.white.withOpacity(0.9),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        FittedBox(
                                                                          fit: BoxFit.scaleDown,
                                                                          child: Text(
                                                                            "@${targetUser.username!}",
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 12,
                                                                              color: Colors.white.withOpacity(0.7),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        if(training.desc!.isNotEmpty)
                                                          Stack(
                                                            clipBehavior: Clip.none,
                                                            children: [
                                                              GlassContainer(
                                                                height: 40,
                                                                color: Colors.black.withOpacity(0.5),
                                                                blur: 10,
                                                                borderRadius: BorderRadius.circular(14),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      ConstrainedBox(
                                                                        constraints: BoxConstraints(
                                                                          maxWidth: size.width * 0.4,
                                                                        ),
                                                                        child: DefaultTextStyle(
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 11,
                                                                            color: Colors.white.withOpacity(0.9),
                                                                          ),
                                                                          child: Text(
                                                                            training.desc!,
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.fade,
                                                                            softWrap: false,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                top: -3,
                                                                right: -2,
                                                                child: Icon(
                                                                  CupertinoIcons.text_bubble_fill,
                                                                  size: 16,
                                                                  color: Colors.white.withOpacity(0.7),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                      ],
                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ),
                            if(!friendppempty)
                              Positioned(
                                top: -15,
                                right: 5,
                                child: GestureDetector(
                                  child: GlassContainer(
                                    height: 30,
                                    color: Colors.black.withOpacity(0.5),
                                    blur: 10,
                                    borderRadius: BorderRadius.circular(18),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Aimé par   ",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          FutureBuilder<Widget>(
                                            future: _friendsPPFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const CupertinoActivityIndicator(radius: 8);
                                              } else if (snapshot.hasError) {
                                                return Text('Erreur : ${snapshot.error}');
                                              } else if (snapshot.hasData) {
                                                return GestureDetector(
                                                  onTapUp: (t) {
                                                  },
                                                  child: snapshot.data!,
                                                );
                                              } else {
                                                return const SizedBox.shrink();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (liked)
                              Positioned(
                                bottom: -10,
                                right: 20,
                                child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Container(
                                      height: 11* size.height/size.width,
                                      width: 13 * size.height/size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white.withOpacity(_colorAnimation.value),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.15),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Transform.scale(
                                        scale: _scaleAnimation.value,
                                        child: Center(
                                          child: Image.asset(
                                            "assets/images/emoji_coeur.png",
                                            height: 7* size.height/size.width,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        )
                    ),
                  ),

                ],
              ),
            ),

          if(loaded)
            Padding(
              padding: EdgeInsets.only(left: size.width*0.052, right: size.width*0.052, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 15, top: 2, bottom: 2, right: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            spreadRadius: 0.3,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/images/emoji_sablier.png", height: 14,),
                                  const SizedBox(width: 2,),
                                  Image.asset("assets/images/emoji_pin.png", height: 14,),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              SizedBox(
                                width: size.width*0.36,
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 6.5 * (size.height / size.width),
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                  child: DateTime.now().day != training.date?.toDate().day
                                      ? Text(
                                    "${formatDateMonth(training.date!.toDate())}, La Défense",
                                    overflow: TextOverflow.ellipsis, // Limite l'affichage
                                    maxLines: 1, // S'assure que le texte reste sur une ligne
                                  )
                                      : Text(
                                    '${training.date?.toDate().hour.toString().padLeft(2, '0')}:${training.date?.toDate().minute.toString().padLeft(2, '0')}, La Défense',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            spreadRadius: 0.3,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTapUp: (t){
                              _handleTap();
                            },
                            child: Container(
                              height: 35,
                              width: size.width*0.18,
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(34),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(formatNumber(training.likes!.length), style: TextStyle(color: Colors.white.withOpacity(1), fontSize: 12, fontWeight: FontWeight.w700),),
                                  const SizedBox(width: 6,),
                                  Icon(CupertinoIcons.heart_fill, color: Colors.white.withOpacity(1), size: 16,)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          GestureDetector(
                            onTapUp: (t){
                              showModalBottomSheet(
                                context: context,
                                barrierColor: Colors.black.withOpacity(0.3),
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      height: size.height * 0.8,
                                      color: Colors.transparent,
                                      child: CommentPage(trn: training),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 35,
                              width: size.width*0.18,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(34),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(formatNumber(training.comments!.length), style: TextStyle(color: Colors.white.withOpacity(1), fontSize: 12, fontWeight: FontWeight.w700),),
                                  const SizedBox(width: 5,),
                                  Icon(CupertinoIcons.bubble_right_fill, color: Colors.white.withOpacity(1), size: 16,)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if(loaded)
            Padding(
              padding: EdgeInsets.only(top: 10, right: size.width*0.052, left: size.width*0.052),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [ BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          spreadRadius: 0.3,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tags", style: TextStyle(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w700, fontSize: 12),),
                                GestureDetector(
                                  onTapUp: (t){
                                    _showActionSheet(context);
                                  },
                                  child: Icon(Icons.more_vert_sharp, color: Colors.black.withOpacity(0.6), size: 16,),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 5,),
                          if(training.tags?.isNotEmpty ?? false)
                            Align(
                              alignment: Alignment.centerLeft,
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
                                            training.tags?.length ?? 0,
                                                (index) => getTag(training.tags![index] ?? "false", false, context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
                            Text("${training.username} n'a pas mit de tags :(", style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w500),),

                          const SizedBox(height: 5,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text("Voir la séance", style: TextStyle(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w700, fontSize: 12),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          /*
          if(loaded)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.055),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IntrinsicWidth(
                        child: Container(
                            height: 13 * (size.height/size.width),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.timer, color: Colors.redAccent, size: 6 * (size.height/size.width),),
                                const SizedBox(width: 10,),
                                DefaultTextStyle(
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 6 * (size.height/size.width),
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                  child: DateTime.now().day != training.date?.toDate().day
                                      ? Text(formatDateMonth(training.date!.toDate()))
                                      : Text('${training.date?.toDate().hour.toString().padLeft(2, '0')}:${training.date?.toDate().minute.toString().padLeft(2, '0')}'),
                                ),
                              ],
                            )
                        ),
                      ),
                      const SizedBox(width: 10,),
                      IntrinsicWidth(
                        child: Container(
                            height: 13 * (size.height/size.width),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.location_fill, color: Colors.redAccent, size: 6 * (size.height/size.width),),
                                const SizedBox(width: 10,),
                                DefaultTextStyle(
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 6 * (size.height/size.width),
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  child: const Text("On air la Défense"),
                                ),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                  IntrinsicWidth(
                      child: GestureDetector(
                        onTapUp: (t){
                          _showActionSheet(context);
                        },
                        child: Container(
                          height: 13 * (size.height/size.width),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                              child: Image.asset("assets/images/emoji_clemolette.png", height: 8 * (size.height/size.width),)
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
          if(loaded)
            SizedBox(height: size.height*0.015),
          if(loaded)
            GestureDetector(
              onDoubleTap: _handleTap,
              child: Container(
                  width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.height * 0.15,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color:  Colors.white,
                    boxShadow: [ BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(formatNumber(training.likes!.length), style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.w600),),
                                Image.asset("assets/images/emoji_coeur.png", height: 18,)
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(formatNumber(377000), style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.w600),),
                                Text("vues", style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w500),),
                              ],
                            ),
                            GestureDetector(
                              onTapUp: (t){
                                showModalBottomSheet(
                                  context: context,
                                  barrierColor: Colors.black.withOpacity(0.3),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(24),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: size.height * 0.8,
                                        color: Colors.transparent,
                                        child: CommentPage(trn: training),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(formatNumber(training.comments!.length), style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.w600),),
                                  Image.asset("assets/images/emoji_com.png", height: 18,)
                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      const SizedBox(height: 15,),
                      if(training.tags?.isNotEmpty ?? false)
                        Align(
                          alignment: Alignment.centerLeft,
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
                                        training.tags?.length ?? 0,
                                            (index) => getTag(training.tags![index] ?? "false", false, context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        Text("${training.username} n'as pas encore mit de tags", style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w500),),
                    ],
                  )
              ),
            ),

           */

          if(!loaded)
            const LoadingTraining(),
        ],
      ),
    );
  }

  String formatDateMonth(DateTime date) {
    DateTime now = DateTime.now();

    List<String> months = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juilliet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];

    String day = date.day.toString();
    String monthAbbr = months[date.month - 1];
    String formattedDate = '$day $monthAbbr';

    if (date.year != now.year) {
      formattedDate += ' ${date.year}';
    }

    return formattedDate;
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Options'),
        actions: <CupertinoActionSheetAction>[
          if(UserModel.currentUser().id != training.userId)
          CupertinoActionSheetAction(
            isDefaultAction: false,
            onPressed: () async {
              Navigator.pop(context);
              await training.report("No sport");
              Haptics.vibrate(HapticsType.light);
            },
            child: const Text("Pas de rapport avec le sport"),
          ),
          if(UserModel.currentUser().id != training.userId)
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InputPage(text: "Raison du signalement", limit: 300),
                ),
              );

              if (result != null) {
                await training.report(result.toString().trim());
                Haptics.vibrate(HapticsType.light);
              }
            },
            child: const Text('Signaler'),
          ),
          if(UserModel.currentUser().id == training.userId)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                showCupertinoDialog<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Supprimer'),
                    content: const Text('Es-tu vraiment sûr de vouloir supprimer ce post ?'),
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
                          training.deletePost();
                        },
                        child: const Text('Oui'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Supprimer'),
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
