import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ProfilPage.dart';

class ProfileListComp extends StatefulWidget {
  final String urlpp;
  final String displayname;
  final String username;
  final bool followed;
  final bool follow;
  final String id;

  const ProfileListComp({
    super.key,
    required this.urlpp,
    required this.displayname,
    required this.username,
    required this.followed,
    required this.follow, required this.id,
  });

  @override
  _ProfileListCompState createState() => _ProfileListCompState();
}

class _ProfileListCompState extends State<ProfileListComp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (t){
        if(widget.id != FirebaseAuth.instance.currentUser?.uid) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProfilPage(id: widget.id),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 80,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: CachedNetworkImageProvider(widget.urlpp),
                ),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w700,
                        fontSize: 5*MediaQuery.of(context).size.width*0.008,
                      ),
                    ),
                    Text(
                      widget.displayname,
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 5*MediaQuery.of(context).size.width*0.007,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if(widget.followed)
              Container(
                height: 30,
                width: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.redAccent.withOpacity(0.3),

                ),
                child: Center(
                  child: Icon(
                    !widget.follow ? CupertinoIcons.person_add_solid : CupertinoIcons.person_2_fill,
                    size: 18,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
