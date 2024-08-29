import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileListComp extends StatefulWidget {
  final String urlpp;
  final String displayname;
  final String username;
  final bool followed;
  final bool friend;

  const ProfileListComp({
    super.key,
    required this.urlpp,
    required this.displayname,
    required this.username,
    required this.followed,
    required this.friend,
  });

  @override
  _ProfileListCompState createState() => _ProfileListCompState();
}

class _ProfileListCompState extends State<ProfileListComp> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Row(
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
                  fontSize: 18,
                ),
              ),
              Text(
                widget.displayname,
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
