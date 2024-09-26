import 'dart:io';

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
import 'package:jymu/screens/home/ProfilPage.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

import 'components/TagList.dart';

class TrainingCard extends StatefulWidget {
  final TrainingModel trn;

  TrainingCard({
    required this.trn,
  });

  @override
  _TrainingCardState createState() => _TrainingCardState();
}

class _TrainingCardState extends State<TrainingCard> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<TrainingCard> {
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
      return (number / 1000).toStringAsFixed(0) + 'k';
    } else {
      return (number / 1000000).toStringAsFixed(0) + 'M';
    }
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


    _updatePalette(true);
    _updatePalette(false);

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
    setState(() {

    });
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
      duration: Duration(milliseconds: 300),
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
    super.build(context);
    return GestureDetector(
      onDoubleTap: _handleTap,
      child: Container(
        height: size.height*0.8,
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(height: size.height*0.07),
            if(loaded)
              SizedBox(height: size.height*0.04),
            if(loaded)
              SizedBox(
                height: size.height*0.58,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 30,
                      child: Container(
                        width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Color(0xffff5d5d),
                          boxShadow: [ BoxShadow(
                            color: !showFirstImage ? firstMainColor.withOpacity(0.3) : showFirstImage ? secondMainColor.withOpacity(0.3) : Colors.black.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, -1),
                          ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            fit: StackFit.expand, // Makes sure the image covers the entire container
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
                      top: 50,
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
                                  spreadRadius: 5,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
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
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 26.0,
                                                              backgroundImage: CachedNetworkImageProvider(pp),
                                                            ),
                                                            SizedBox(width: 5,),
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
                                                                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                                                                  padding: EdgeInsets.symmetric(horizontal: 15),
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
                                            offset: Offset(0, 2),
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
              padding: EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                            training.tags!.length,
                                (index) => getTag(training.tags![index] ?? "none", false)
                        )
                    ),
                  ),
                )
              ),
            ),
            if(!loaded)
              LoadingTraining(),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
