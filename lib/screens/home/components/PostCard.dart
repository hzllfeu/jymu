import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jymu/PostManager.dart';
import 'package:jymu/screens/home/ProfilPage.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final String username;
  final String content;
  final DateTime postTime;
  final String userId;
  final List<dynamic> likes;
  final String postID;

  PostCard({
    required this.username,
    required this.content,
    required this.postTime,
    required this.userId,
    required this.likes, required this.postID,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin {
  bool liked = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;
  late Animation<double> _marginAnimation;

  @override
  void initState() {
    super.initState();
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

    if(widget.likes.contains(FirebaseAuth.instance.currentUser?.uid)){
      setState(() {
        liked = true;
        _controller.forward();
      });
    }
  }

  Future<String> getProfileImageUrl(String uid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('user_profiles/$uid.jpg');
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      print('Erreur lors de la récupération de l\'image de profil : $e');
      return 'https://via.placeholder.com/150'; // URL par défaut en cas d'erreur
    }
  }

  void _handleTap() {
    setState(() {
      liked = !liked;
      if (liked) {
        _controller.forward();
        addLike(widget.postID, FirebaseAuth.instance.currentUser!.uid);
      } else {
        _controller.reverse();
        removeLike(widget.postID, FirebaseAuth.instance.currentUser!.uid);
      }
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int tmp = widget.likes.length - 1;
    return FutureBuilder<String>(
      future: getProfileImageUrl(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement de l\'image'));
        }

        final profileImageUrl = snapshot.data ?? 'https://via.placeholder.com/150';

        return GestureDetector(
          onDoubleTap: _handleTap,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20, bottom: liked ? 30 : 15),
                padding: EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTapUp: (t){
                            if(widget.userId != FirebaseAuth.instance.currentUser?.uid) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilPage(id: widget.userId),
                                ),
                              );
                            }
                          },
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: CachedNetworkImageProvider(profileImageUrl),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        GestureDetector(
                          onTapUp: (t){
                            if(widget.userId != FirebaseAuth.instance.currentUser?.uid) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilPage(id: widget.userId),
                                ),
                              );
                            }
                          },
                          child: Expanded(
                            child: Text(
                              widget.username,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.label,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          timeago.format(widget.postTime, locale: 'fr'),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      widget.content,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTapUp: (t){
                                _handleTap();
                              },
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.redAccent.withOpacity(0.1),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.likes.length.toString(),
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Image.asset(
                                      "assets/images/emoji_coeur.png",
                                      height: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              widget.username,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "et",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(
                              "$tmp autres",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          CupertinoIcons.text_bubble,
                          color: Colors.black.withOpacity(0.6),
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (liked)
                Positioned(
                  bottom: 15,
                  right: 70,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Container(
                          height: 25,
                          width: 33,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.redAccent.withOpacity(_colorAnimation.value),
                          ),
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Center(
                            child: Image.asset(
                              "assets/images/emoji_coeur.png",
                              height: 18,
                              width: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
