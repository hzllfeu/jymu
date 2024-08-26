import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostCardLittle extends StatefulWidget {
  final String username;
  final DateTime time;
  final String id;

  PostCardLittle({
    required this.username, required this.time, required this.id,
  });

  @override
  _PostCardLittleState createState() => _PostCardLittleState();
}


class _PostCardLittleState extends State<PostCardLittle> with SingleTickerProviderStateMixin {
  Future<String>? pp;
  String urlpp = "";

  @override
  void initState() {
    super.initState();
    pp = getProfileImageUrl(widget.id);
  }

  Future<String> getProfileImageUrl(String uid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('user_profiles/$uid.jpg');
      final url = await storageRef.getDownloadURL();
      setState(() {
        urlpp = url;
      });
      return url;
    } catch (e) {
      print('Erreur lors de la récupération de l\'image de profil : $e');
      return 'https://via.placeholder.com/150';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 10),
      width: 122,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14.0,
            backgroundImage: CachedNetworkImageProvider(urlpp),
          ),
          const SizedBox(height: 9),
           Text(
             widget.username,
             style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w600),
           )
        ],
      ),
    );
  }
}
