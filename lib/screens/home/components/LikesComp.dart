import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../PostManager.dart';
import '../LoadingPost.dart';
import 'PostCard.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class LikeComp extends StatefulWidget {
  final List<dynamic> likes;

  const LikeComp({super.key, required this.likes});

  static String routeName = "/";

  @override
  State<LikeComp> createState() => _LikeCompState();
}

class _LikeCompState extends State<LikeComp> {
  bool _isLoading = true;
  List<DocumentSnapshot> likedPosts = [];

  @override
  void initState() {
    super.initState();
    _fetchLikedPosts();
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _fetchLikedPosts() async {
    List<DocumentSnapshot> tempLikedPosts = [];

    for (var like in widget.likes) {
      print(like);
      String postId = like['postId'];
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();

      if (postSnapshot.exists) {
        tempLikedPosts.add(postSnapshot);
      }
    }

    setState(() {
      likedPosts = tempLikedPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.likes.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Center( // Utilisation de Center à la place de Expanded
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Icon(CupertinoIcons.nosign, color: CupertinoColors.systemGrey, size: 46),
              const SizedBox(height: 10),
              Text(
                "Il n'y a pas encore de like",
                style: TextStyle(color: CupertinoColors.systemGrey, fontWeight: FontWeight.w600, fontSize: 18),
              )
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: SizedBox(
          height: 355,
          child: ListView.builder( // Pas besoin d'Expanded ici
            itemCount: likedPosts.length,
            itemBuilder: (context, index) {
              final post = likedPosts[index].data() as Map<String, dynamic>;

              return PostCard(
                username: post['username'],
                content: post['content'],
                postTime: (post['postTime'] as Timestamp).toDate(),
                userId: post['id'],
                likes: post['likes'],
                postID: likedPosts[index].id,
              );
            },
          ),
        ),
      );
    }
  }
}
