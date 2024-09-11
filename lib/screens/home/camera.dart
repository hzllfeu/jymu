import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:camera/camera.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/Alexis/ia_gene.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import '../../main.dart';


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
  final Duration animationDuration = Duration(milliseconds: 1000);

  late File fistImage;
  late File secondImage;
  bool firstTaken = false;
  bool secondTaken = false;
  bool showLoading = false;
  Color firstMainColor = Colors.transparent;
  Color secondMainColor = Colors.transparent;

  late final TabController tabController;
  bool isFirstSelected = true;
  bool isSecondSelected = false;

  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _hasAnimated = false;
  bool showFirstImage = true;

  bool posting = false;

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


  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
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

    _startLiveFeed();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.04))
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationController);
  }

  @override
  void dispose() {
    // _stopLiveFeed();
    _animationController.dispose();
    super.dispose();
  }

  void _checkAndAnimate() {
    if (!_hasAnimated && firstTaken && (isFrontImageTaken || !isFrontImageTaken)) {
      _animationController.forward().then((_) => _animationController.reverse());
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

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: size.height*0.02),
          if(!firstTaken && !secondTaken)
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
                      Tab(text: 'Training'),
                      Tab(text: 'Post'),
                    ],
                  ),
                ),
              ),
            ),
          if(firstTaken && secondTaken)
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
                    child: Container(
                      height: 38,
                      width: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.redAccent.withOpacity(0.9),
                            Colors.deepOrange.withOpacity(0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Annuler",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 7*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), color: Colors.white.withOpacity(0.9)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTapUp: (t) async {
                      setState(() {
                        posting = true;
                      });
                      Haptics.vibrate(HapticsType.light);
                      await pushToServer("");
                      Haptics.vibrate(HapticsType.success);
                      setState(() {
                        posting = false;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 38,
                      width: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.redAccent.withOpacity(0.9),
                            Colors.deepOrange.withOpacity(0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(!posting)
                            Text(
                              "Poster",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 7*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), color: Colors.white.withOpacity(0.9)),
                            )
                          else
                            CupertinoActivityIndicator(color: Colors.white)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: size.height*0.05),
          SizedBox(
            height: size.height*0.6,
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
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.redAccent.withOpacity(0.6),
                          Colors.deepOrange.withOpacity(0.6),
                        ],
                      ),
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
                          ).blur(blur: 2),
                          // Other widgets like overlays can go here (e.g., CameraPreview)
                        ],
                      ),
                    ),
                  ),
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
                          color: firstTaken && showFirstImage ? firstMainColor.withOpacity(0.5) : secondTaken && !showFirstImage ? secondMainColor.withOpacity(0.5) : Colors.black.withOpacity(0.2),
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
                            height: _controller?.value.isInitialized != false && _controller != null
                                ? _controller!.value.previewSize!.width
                                : sizeX,
                            width: _controller?.value.isInitialized != false && _controller != null
                                ? _controller!.value.previewSize!.height
                                : sizeY,
                            child: Stack(
                              alignment: Alignment.center,
                              fit: StackFit.expand,
                              children: [
                                if (!_changingCameraLens) CameraPreview(_controller!),
                                if (firstTaken && isFrontImageTaken)
                                  Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..scale(-1.0, 1.0),
                                    child: GestureDetector(
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
                                  ),
                                if (firstTaken && !isFrontImageTaken)
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
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CupertinoActivityIndicator(color: Colors.white, radius: 18,),
                                        SizedBox(height: 10),
                                        Text(
                                          "Souris, on est entrain de prendre la deuxieme photo !",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 32),
                                          textAlign: TextAlign.center, // Centre le texte
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 40,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _cameraIndex == 1
                    ? () {
                  HapticFeedback.heavyImpact();
                }
                    : _flashEnable,
                child: Icon(
                  flashEnabled ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              Container(
                width: 25,
              ),
              GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 6),
                        shape: BoxShape.circle,
                      ))),
              Container(
                width: 25,
              ),
              GestureDetector(
                onTap: _switchFrontCamera,
                child: AnimatedBuilder(
                  animation: rotationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: rotationController!.value * 2.0 * pi,
                      child: child,
                    );
                  },
                  child: Transform(
                    transform: Matrix4.identity()..scale(-1.0, 1.0, -1.0),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.loop_rounded,
                      color: Colors.black,
                      size: 37,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
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

    await Future.delayed(Duration(milliseconds: 500));
    HapticFeedback.heavyImpact();

    final XFile firstImageFile = await _controller!.takePicture();

    setState(() {
      fistImage = File(firstImageFile.path);
      firstTaken = true;
      _changingCameraLens = true;
      showLoading = true;
      if(_cameraIndex == 1){
        isFrontImageTaken = true;
      }
    });

    _updatePalette(false);
    _checkAndAnimate();

    await _switchFrontCamera();

    await Future.delayed(const Duration(milliseconds: 800));

    final XFile secondImageFile = await _controller!.takePicture();
    HapticFeedback.mediumImpact();

    setState(() {
      secondImage = File(secondImageFile.path);
      secondTaken = true;
      showLoading = false;
    });
    _updatePalette(true);



  }

  Future _switchFrontCamera() async {
    HapticFeedback.heavyImpact();

    setState(() => _changingCameraLens = true); // Indicate the camera is switching.

    // Check if the current camera is back (0) or external (2) and switch to front.
    if (_cameraIndex == 0 || _cameraIndex == 2) {
      _cameraIndex = 1; // Switch to front camera.
    } else {
      _cameraIndex = 0; // Switch back to the back camera.
    }

    await _stopLiveFeed();

    if(firstTaken){
      await Future.delayed(const Duration(milliseconds: 1200));
    }

    await _startLiveFeed();

    setState(() => _changingCameraLens = false);

  }

  Future _stopLiveFeed() async {
    _controller = null;
  }

  Future _flashEnable() async {
    HapticFeedback.heavyImpact();
    if (flashEnabled) {
      setState(() {
        flashEnabled = false;
      });
      _controller!.setFlashMode(FlashMode.off);
    } else {
      setState(() {
        flashEnabled = true;
      });
      _controller!.setFlashMode(FlashMode.torch);
    }
  }

  Future _switchGiantAngle() async {
    HapticFeedback.heavyImpact();
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

  Future<void> pushToServer(String desc)async {
    await uploadImageToStorage(fistImage);
    await uploadImageToStorage(secondImage);

  }
}