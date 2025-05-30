import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:camera/camera.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/Alexis/ia_gene.dart';
import 'package:jymu/Models/UserModel.dart';
import 'package:jymu/UserManager.dart';
import 'package:jymu/screens/home/ModifyTags.dart';
import 'package:jymu/screens/home/PostWidget.dart';
import 'package:jymu/screens/home/components/TagList.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../Models/NotificationService.dart';
import '../../main.dart';
import 'package:image/image.dart' as img;

import '../InputPage.dart';
import '../init_screen.dart';


class CameraPage extends StatefulWidget {
  CameraPage(
      {Key? key, this.text, this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final String? text;
  final CameraLensDirection initialDirection;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  CameraController? _controller;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  int _cameraIndex = -1;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  bool _changingCameraLens = false;
  bool flashEnabled = false;
  String frontImagePath = "";
  String backImagePath = "";
  bool isFrontImageTaken = false;
  bool isBackImageTaken = false;
  double sizeX = 0;
  double sizeY = 0;
  AnimationController? rotationController;
  final Duration animationDuration = Duration(milliseconds: 200);

  late File fistImage;
  late File secondImage;
  late File TempImage;
  bool isTempTaken = false;
  bool firstTaken = false;
  bool secondTaken = false;
  bool showLoading = false;
  bool giantAngle = false;
  Color firstMainColor = Colors.transparent;
  Color secondMainColor = Colors.transparent;
  Color tempMainColor = Colors.transparent;

  late final TabController tabController;
  bool isFirstSelected = true;
  bool isSecondSelected = false;

  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late AnimationController _animationControllerbis;
  late Animation<Offset> _animationbis;
  bool _hasAnimated = false;
  bool showFirstImage = true;
  String ppurl = "";
  String desc = "";

  bool posting = false;
  Timer? _timer;
  late FocusNode _focusNode;
  bool isFocused = false;

  List<dynamic> tags = [];


  Future<void> _updatePalette(bool b) async {
    if(b == false){
      final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image.file(fistImage).image,
      );

      setState(() {
        firstMainColor = paletteGenerator.dominantColor?.color ?? Colors.transparent;
      });
    } else {
      final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image.file(secondImage).image,
      );

      setState(() {
        secondMainColor = paletteGenerator.dominantColor?.color ?? Colors.transparent;
      });
    }
  }

  Future<void> temppalette() async {
      final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image.file(TempImage).image,
      );

      setState(() {
        tempMainColor = paletteGenerator.dominantColor?.color ?? Colors.transparent;
      });
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
      String tmp = await getProfileImageUrl(FirebaseAuth.instance.currentUser!.uid);

      if (!mounted) return;
      setState(() {
        ppurl = tmp;
      });
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _fetchProfileImageUrl();
    setState(() {
      tags = getTagList().take(2).toList();
    });

    rotationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    if (cameras.any(
          (element) =>
      element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
        element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == widget.initialDirection) {
          _cameraIndex = i;
          break;
        }
      }
    }

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });

    _startLiveFeed();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.04))
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationController);

    _animationControllerbis = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animationbis = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.04))
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationControllerbis);
  }

  @override
  void dispose() {
    // _stopLiveFeed();
    _animationController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      _executeFunction();
    });
  }

  Future<void> _executeFunction() async {
    if(_controller != null && !_changingCameraLens){
      final XFile temp = await _controller!.takePicture();
      setState(() {
        TempImage = File(temp.path);
        isTempTaken = true;
        temppalette();
      });
    }
  }



  void _checkAndAnimate() {
    if (!_hasAnimated && firstTaken && (isFrontImageTaken || !isFrontImageTaken)) {
      _animationController.forward().then((_) => _animationController.reverse());
    }
  }
  void _checkAndAnimateBis() {
    if (!_hasAnimated && secondTaken && (isFrontImageTaken || !isFrontImageTaken)) {
      _animationControllerbis.forward().then((_) => _animationControllerbis.reverse());
    }
  }

  Future<String> uploadImageToStorage(File file) async {
    String fileName = Path.basename(file.path);
    Reference storageRef = _storage.ref().child('images/$fileName');
    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      body: _body(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _body() {
    final size = MediaQuery.of(context).size;

    return Container(
        width: double.infinity,
        child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.redAccent,
                        Colors.deepOrange,
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 70,
                child: SizedBox(
                  width: size.width,
                  child: Column(
                    children: [
                      if(!firstTaken || !secondTaken)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTapUp: (t) {
                                  Navigator.pop(context);
                                },
                                child: GlassContainer(
                                    height: 38,
                                    color: Colors.white.withOpacity(0.8),
                                    blur: 10,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Center(
                                        child: Icon(
                                          CupertinoIcons.arrow_left,
                                          size: 22,
                                          color: CupertinoColors.black.withOpacity(0.8),
                                        ),
                                      ),
                                    )
                                ),


                              ),
                              GestureDetector(
                                onTapUp: (t) async {
                                  Haptics.vibrate(HapticsType.light);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                        body: NewPostWidget(),
                                      ),
                                    ),
                                  );
                                },
                                child: GlassContainer(
                                  height: 38,
                                  color: Colors.white.withOpacity(0.8),
                                  blur: 10,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Center(
                                      child: Text(
                                        "Faire un post écrit",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600, fontSize: 7*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), color: Colors.black.withOpacity(0.7)),
                                      ),
                                    )
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      if(firstTaken && secondTaken && !isFocused)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width*0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTapUp: (t)  {
                                  if(!posting){
                                    Navigator.pop(context);
                                  }
                                },
                                child: GlassContainer(
                                    height: 38,
                                    color: Colors.white.withOpacity(0.8),
                                    blur: 10,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Center(
                                        child: Text(
                                          "Annuler",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600, fontSize: 7*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), color: Colors.black.withOpacity(0.7)),
                                        ),
                                      )
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTapUp: (t) async {
                                  setState(() {
                                    posting = true;
                                  });
                                  Haptics.vibrate(HapticsType.light);
                                  await pushToServer(desc, tags);
                                  Haptics.vibrate(HapticsType.success);
                                  setState(() {
                                    posting = false;
                                  });
                                  Navigator.pop(context);
                                  await Future.delayed(const Duration(milliseconds: 300));
                                  InterMessageManager().showmessage(text: "Posté", context: context);
                                },
                                child: GlassContainer(
                                    height: 38,
                                    color: Colors.white.withOpacity(0.8),
                                    blur: 10,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if(!posting)
                                            Text(
                                              "Poster",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 7*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), color: Colors.black.withOpacity(0.7)),
                                                  )
                                          else
                                            CupertinoActivityIndicator(color: Colors.black.withOpacity(0.7)),
                                          if(!posting)
                                            SizedBox(width: 10,),
                                          if(!posting)
                                            Icon(CupertinoIcons.chevron_right_circle, color: Colors.black.withOpacity(0.7), size: 16,)
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
                )
              ),

              Positioned(
                  top: MediaQuery.of(context).size.height * 0.25 - 50,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8 + 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F5F8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28.0),
                        topRight: Radius.circular(28.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height*0.58,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                    top: 30,
                                    child: SlideTransition(
                                      position: _animationbis,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.2,
                                        height: MediaQuery.of(context).size.height * 0.4,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(18),
                                          color: Color(0xffff5d5d),
                                          boxShadow: [ BoxShadow(
                                            color: firstTaken && !showFirstImage ? firstMainColor.withOpacity(0.3) : secondTaken && showFirstImage ? secondMainColor.withOpacity(0.3) : isTempTaken ? tempMainColor.withOpacity(0.5): Colors.black.withOpacity(0.3),
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: const Offset(0, -1),
                                          ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(18),
                                          child: Stack(
                                            fit: StackFit.expand, // Makes sure the image covers the entire container
                                            children: [
                                              if(secondTaken)
                                                Image(
                                                  image: showFirstImage ? Image.file(secondImage).image : Image.file(fistImage).image,
                                                  fit: BoxFit.cover,
                                                ).blur(blur: 3)
                                              else if(ppurl != "")
                                                Image(
                                                  image: CachedNetworkImageProvider(ppurl),
                                                  fit: BoxFit.cover,
                                                ).blur(blur: 3)
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                Positioned(
                                  top: 50,
                                  child: SlideTransition(
                                    position: _animation,
                                    child: Container(
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
                                          color: firstTaken && showFirstImage ? firstMainColor.withOpacity(0.5) : secondTaken && !showFirstImage ? secondMainColor.withOpacity(0.5) : isTempTaken ? tempMainColor.withOpacity(0.5): Colors.black.withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: SizedBox(
                                              height: _controller?.value.isInitialized != false && _controller != null
                                                  ? _controller!.value.previewSize!.width
                                                  : sizeX,
                                              width: _controller?.value.isInitialized != false && _controller != null
                                                  ? _controller!.value.previewSize!.height
                                                  : sizeY,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Stack(
                                                    alignment: Alignment.center,
                                                    fit: StackFit.expand,
                                                    children: [
                                                      if (!_changingCameraLens || (_controller != null && !firstTaken))
                                                        CameraPreview(_controller!),

                                                      if (firstTaken)
                                                        GestureDetector(
                                                          onTapUp: (t){
                                                            if(firstTaken && secondTaken){
                                                              setState(() {
                                                                showFirstImage = !showFirstImage;
                                                              });
                                                              HapticFeedback.lightImpact();
                                                              _checkAndAnimate();
                                                            }
                                                          },
                                                          child: Image.file(showFirstImage ? fistImage : secondImage),
                                                        ),
                                                      if (showLoading)
                                                        Align(
                                                          alignment: Alignment.center,
                                                          child: GlassContainer(
                                                            height: 250,
                                                            width: 550,
                                                            color: Colors.black.withOpacity(0.5),
                                                            blur: 10,
                                                            borderRadius: BorderRadius.circular(45),
                                                            child: const Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                CupertinoActivityIndicator(color: Colors.white, radius: 18,),
                                                                SizedBox(height: 10),
                                                                Text(
                                                                  "Contracte, on te prend en photo !",
                                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 28),
                                                                  textAlign: TextAlign.center, // Centre le texte
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  if (!_changingCameraLens && !firstTaken)
                                                    Positioned(
                                                        bottom: 350,
                                                        child: SizedBox(
                                                          width: (_controller?.value.isInitialized != false && _controller != null
                                                              ? _controller!.value.previewSize!.height
                                                              : sizeY) - 40,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: _cameraIndex == 1
                                                                    ? () {
                                                                  HapticFeedback.heavyImpact();
                                                                }
                                                                    : _flashEnable,
                                                                child: GlassContainer(
                                                                  height: 105,
                                                                  width: 315,
                                                                  color: Colors.black.withOpacity(0.5),
                                                                  blur: 10,
                                                                  borderRadius: BorderRadius.circular(30),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      DefaultTextStyle(
                                                                        style: TextStyle(
                                                                          fontWeight: FontWeight.w700,
                                                                          fontSize: 36,
                                                                          color: Colors.white.withOpacity(0.7),
                                                                        ),
                                                                        child: Text("Flash  "),
                                                                      ),
                                                                      SizedBox(width: 5),
                                                                      Icon(Icons.flash_on_rounded, size: 38, color: Colors.white,),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              if(_controller!.description.lensDirection == CameraLensDirection.back)
                                                                SizedBox(width: 30,),
                                                              if(_controller!.description.lensDirection == CameraLensDirection.back)
                                                                GestureDetector(
                                                                  onTapUp: (t) async{
                                                                    await _switchGiantAngle();
                                                                    setState(() {
                                                                      giantAngle = !giantAngle;
                                                                    });
                                                                  },
                                                                  child: GlassContainer(
                                                                      height: 120,
                                                                      width: 150,
                                                                      color: Colors.black.withOpacity(0.5),
                                                                      blur: 10,
                                                                      borderRadius: BorderRadius.circular(45),
                                                                      child:Center(
                                                                        child: Icon(!giantAngle ? CupertinoIcons.arrow_down_right_arrow_up_left : CupertinoIcons.arrow_up_left_arrow_down_right, color: Colors.white, size: 45,),
                                                                      )
                                                                  ),
                                                                ),
                                                              SizedBox(width: 30,),
                                                              GestureDetector(
                                                                onTap: _switchFrontCamera,
                                                                child: GlassContainer(
                                                                  height: 105,
                                                                  width: 315,
                                                                  color: Colors.black.withOpacity(0.5),
                                                                  blur: 10,
                                                                  borderRadius: BorderRadius.circular(30),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      DefaultTextStyle(
                                                                        style: TextStyle(
                                                                          fontWeight: FontWeight.w700,
                                                                          fontSize: 36,
                                                                          color: Colors.white.withOpacity(0.7),
                                                                        ),
                                                                        child: Text("Retourner  "),
                                                                      ),
                                                                      SizedBox(width: 5),
                                                                      Icon(CupertinoIcons.arrow_2_squarepath, size: 38, color: Colors.white,),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                  if(firstTaken && secondTaken)
                                                    Positioned(
                                                      bottom: 350,
                                                      child: GestureDetector(
                                                        onTapUp: (t) async{
                                                        },
                                                        child: GlassContainer(
                                                          height: 140,
                                                          width: (_controller?.value.isInitialized != false && _controller != null
                                                              ? _controller!.value.previewSize!.height
                                                              : sizeY) - 40,
                                                          color: Colors.black.withOpacity(0.5),
                                                          blur: 10,
                                                          borderRadius: BorderRadius.circular(45),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              SizedBox(
                                                                  width: (_controller?.value.isInitialized != false && _controller != null
                                                                      ? _controller!.value.previewSize!.height
                                                                      : sizeY) - 150,
                                                                  child: Center(
                                                                      child: GestureDetector(
                                                                          onTapUp: (t) async {
                                                                            final result = await Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => InputPage(text: "Ajouter une description", limit: 23),
                                                                              ),
                                                                            );

                                                                            if (result != null) {
                                                                              desc = result;
                                                                              setState(() {});
                                                                            }
                                                                          },
                                                                          child: Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Text(
                                                                              desc.isEmpty? "Ecris ici une courte description...": desc,
                                                                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 40, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          )
                                                                      )
                                                                  )
                                                              ),
                                                              Icon(CupertinoIcons.pen, color: Colors.white.withOpacity(0.7), size: 46,),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if(!isFocused)
                            SizedBox(height: size.height*0.01),
                          if(!firstTaken || !secondTaken)
                            SizedBox(height: size.height*0.05),
                          if(!firstTaken || !secondTaken && !showLoading) //TODO Annimation
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                  onTap: _takePicture,
                                  child: Container(
                                    width: size.width*0.7,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(34),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.deepOrange.withOpacity(0.15),
                                          spreadRadius: 3,
                                          blurRadius: 14,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "PRENDRE",
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 34,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        Icon(Icons.arrow_forward_ios_rounded, size: 34, weight: 28, color: Colors.redAccent,),
                                      ],
                                    ),
                                  )
                              ),
                            ),
                          if(firstTaken && secondTaken)
                            SizedBox(width: 20,),
                          if(firstTaken && secondTaken)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Tags suggérés", style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600,fontSize: 14)),
                                  GestureDetector(
                                    onTapUp: (t) async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ModifyTags(tags: tags),
                                        ),
                                      );
                                      if (result != null) {
                                        tags = result;
                                        setState(() {});
                                      }
                                    },
                                    child: Text("Voir plus", style: TextStyle(color: CupertinoColors.systemRed, fontWeight: FontWeight.w500,fontSize: 14)),
                                  )
                                ],
                              ),
                            ),
                          if(firstTaken && secondTaken)
                            SizedBox(width: 10,),
                          if(firstTaken && secondTaken)
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: SizedBox(
                                height: 40,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: List.generate(
                                          tags.length,
                                              (index) => getTag(tags[index] ?? "none", false, context)
                                      )
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    )
                  )
              )
            ]
        )
    );
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      sizeX = _controller!.value.previewSize!.width;
      sizeY = _controller!.value.previewSize!.height;
      // _controller?.getMinZoomLevel().then((value) {
      //   zoomLevel = value;
      //   minZoomLevel = value;
      // });
      // _controller?.getMaxZoomLevel().then((value) {
      //   maxZoomLevel = value;
      // });
      // _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });

  }

  Future<void> _takePicture() async {

    HapticFeedback.heavyImpact();

    if(flashEnabled){
      await _controller!.setFlashMode(FlashMode.always);
    }
    else{
      await _controller!.setFlashMode(FlashMode.off);
    }
    final XFile firstImageFile = await _controller!.takePicture();
    File imageFile = File(firstImageFile.path);

    if (_controller!.description.lensDirection == CameraLensDirection.front) {
      final img.Image capturedImage = img.decodeImage(imageFile.readAsBytesSync())!;

      final img.Image mirroredImage = img.flipHorizontal(capturedImage);

      imageFile.writeAsBytesSync(img.encodeJpg(mirroredImage));
    }

    setState(() {
      fistImage = imageFile;
      firstTaken = true;
    });

    setState(() {
      _changingCameraLens = true;
      showLoading = true;
      if(_cameraIndex == 1){
        isFrontImageTaken = true;
      }
    });


    await Future.delayed(const Duration(milliseconds: 400));

    await _switchFrontCamera();

    await Future.delayed(const Duration(milliseconds: 800));

    if(flashEnabled){
      await _controller!.setFlashMode(FlashMode.always);
    }
    else{
      await _controller!.setFlashMode(FlashMode.off);
    }
    final XFile secondImageFile = await _controller!.takePicture();
    imageFile = File(secondImageFile.path);

    if (_controller!.description.lensDirection == CameraLensDirection.front) {
      final img.Image capturedImage = img.decodeImage(imageFile.readAsBytesSync())!;

      final img.Image mirroredImage = img.flipHorizontal(capturedImage);

      imageFile.writeAsBytesSync(img.encodeJpg(mirroredImage));
    }
    HapticFeedback.lightImpact();


    setState(() {
      secondImage = imageFile;
      secondTaken = true;
      showLoading = false;
    });
    _checkAndAnimateBis();
  }

  Future _switchFrontCamera() async {

    setState(() => _changingCameraLens = true); // Indicate the camera is switching.

    // Check if the current camera is back (0) or external (2) and switch to front.
    if (_cameraIndex == 0 || _cameraIndex == 2) {
      _cameraIndex = 1; // Switch to front camera.
    } else {
      _cameraIndex = 0; // Switch back to the back camera.
    }

    await _stopLiveFeed();

    await _startLiveFeed();

    setState(() => _changingCameraLens = false);

  }

  Future _stopLiveFeed() async {
    _controller = null;
  }

  Future _flashEnable() async {
    Haptics.vibrate(HapticsType.light);
    if (flashEnabled) {
      setState(() {
        flashEnabled = false;
      });
    } else {
      setState(() {
        flashEnabled = true;
      });
    }
  }

  Future _switchGiantAngle() async {
    HapticFeedback.lightImpact();
    if (_cameraIndex == 2) {
      setState(() => _changingCameraLens = true);
      _cameraIndex = 0;
      await _stopLiveFeed();
      await _startLiveFeed();
      setState(() => _changingCameraLens = false);
    } else {
      setState(() => _changingCameraLens = true);
      _cameraIndex = 2;

      await _stopLiveFeed();
      await _startLiveFeed();
      setState(() => _changingCameraLens = false);
    }
  }

  Future<void> pushToServer(String desc, List<dynamic> tags) async {
    String firstPath = '${UserModel.currentUser().id}_${Path.basename(fistImage.path)}}.jpg';
    String secondPath = '${UserModel.currentUser().id}_${Path.basename(secondImage.path)}}.jpg';
    await uploadToStorage(fistImage, firstPath);
    await uploadToStorage(secondImage, secondPath);
    await postTraining(firstPath, secondPath, desc, tags);
  }
}

Future<void> uploadToStorage(File imageFile, String fileName) async {
  try {
    Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');

    UploadTask uploadTask = storageReference.putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    print('File uploaded successfully: $downloadUrl');
  } catch (e) {
    print('Error uploading file: $e');
  }
}

Future<void> postTraining(String path1, String path2, String desc, List<dynamic> tags) async {
  final uuid = Uuid();
  final trainingCollection = FirebaseFirestore.instance.collection('trainings');

  String trainingId = uuid.v4();

  await trainingCollection.doc(trainingId).set({
    'trainingId': trainingId,
    'id': UserModel.currentUser().id,
    'displayname': UserModel.currentUser().displayName,
    'username': UserModel.currentUser().username,
    'date': Timestamp.now(),
    'desc': desc,
    'likes': [],
    'comments': [],
    'tags': tags,
    'seance': [],
    'firstImage': path1,
    'secondImage': path2,
  });

  sendPushNotification(UserModel.currentUser().id!, "a posté un nouveau training.", "${UserModel.currentUser().username}",  "", true, "", "", "post", "");

  UserModel.currentUser().trainings?.add([{'training': trainingId, 'timestamp': Timestamp.now()}]);
  addTraining(UserModel.currentUser().id!, trainingId, Timestamp.now());
}