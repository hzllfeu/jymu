import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/PostManager.dart';
import 'package:jymu/screens/home/ProfilPage.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:timeago/timeago.dart' as timeago;

class TrainingCard extends StatefulWidget {
  final String? username;
  final String userId;

  TrainingCard({
    required this.username,
    required this.userId,
  });

  @override
  _TrainingCardState createState() => _TrainingCardState();
}

class _TrainingCardState extends State<TrainingCard> with SingleTickerProviderStateMixin {
  bool liked = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;
  late Animation<double> _marginAnimation;
  Color topColor = Colors.transparent;
  Color bottomColor = Colors.transparent;
  Color leftColor = Colors.transparent;
  Color rightColor = Colors.transparent;

  Future<void> _updatePalette() async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider('https://picsum.photos/600'),
    );

    setState(() {
      topColor = paletteGenerator.dominantColor?.color ?? Colors.transparent;
      bottomColor = paletteGenerator.lightVibrantColor?.color ?? Colors.transparent;
      leftColor = paletteGenerator.darkMutedColor?.color ?? Colors.transparent;
      rightColor = paletteGenerator.vibrantColor?.color ?? Colors.transparent;
    });
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _updatePalette();

    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _colorAnimation = Tween<double>(begin: 0.0, end: 0.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _marginAnimation = Tween<double>(begin: 15.0, end: 30.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

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



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProfileImageUrl(widget.userId), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CupertinoActivityIndicator(radius: 18,);
          } else{
            return SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.6,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 30,
                          child: Container(
                            width: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width*0.2,
                            height: MediaQuery.of(context).size.height*0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                              color: Colors.deepOrange,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  'https://picsum.photos/350/600',
                                ),
                              ),
                            ),
                          ),
                        ),
              Positioned(
                top: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider('https://picsum.photos/600'),
                    ),
                    // Add shadows with extracted colors
                    boxShadow: [
                      BoxShadow(
                        color: topColor.withOpacity(0.3), // Bottom shadow
                        offset: Offset(0, 3),
                        blurRadius: 15,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: topColor.withOpacity(0.3), // Left shadow
                        offset: Offset(-3, 0),
                        blurRadius: 15,
                        spreadRadius:4,
                      ),
                      BoxShadow(
                        color: topColor.withOpacity(0.3), // Right shadow
                        offset: Offset(3, 0),
                        blurRadius: 15,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              )
                      ],
                    ),
                  )
                ],
              )
            );
          }
        }
    );
  }
}
