import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Models/UserModel.dart';
import 'package:jymu/screens/ProfilPageBis.dart';
import 'package:jymu/screens/home/LoadingProfileList.dart';
import 'package:jymu/screens/home/RecherchePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/CachedData.dart';
import 'CommentListComp.dart';


class ProfileListComp extends StatefulWidget {
  final String id;
  final bool recent;
  final bool search;

  const ProfileListComp({
    super.key, required this.id, required this.recent, required this.search,
  });

  @override
  _ProfileListCompState createState() => _ProfileListCompState();
}

class _ProfileListCompState extends State<ProfileListComp> {
  Future<void>? data;
  String pp = "";
  UserModel user = UserModel();
  bool followed = false;
  bool friend = false;

  Future<void> loadData() async {
    if(CachedData().users.containsKey(widget.id)){
      user = CachedData().users[widget.id]!;
    } else {
      await user.fetchExternalData(widget.id);
      CachedData().users[widget.id] = user;
    }
    if(CachedData().links.containsKey(widget.id)){
      pp = CachedData().links[widget.id]!;
    } else {
      pp = await getProfileImageUrl(widget.id);
      CachedData().links[widget.id] = pp;
    }
    if(user.id != UserModel.currentUser().id){
      if(user.follow!.cast<String>().contains(UserModel.currentUser().id)){
        followed = true;
      }
      if(UserModel.currentUser().follow!.cast<String>().contains(user.id) && followed){
        friend = true;
      }
    }
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    data = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingProfileList();
        } else if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        } else if (snapshot.hasData) {
          return const LoadingProfileList();
        } else {
          return GestureDetector(
            onTapUp: (t){
              if(widget.search){
                RecentlyViewedManager.instance.addRecentlyViewedId(widget.id);
              }
              if(widget.id != FirebaseAuth.instance.currentUser?.uid) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilPageBis(id: widget.id),
                  ),
                );
              }
            },
            child: Container(
              width: double.infinity,
              height: 70,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 23.0,
                        backgroundImage: CachedNetworkImageProvider(pp),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username!,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w700,
                              fontSize: 5*MediaQuery.of(context).size.width*0.007,
                            ),
                          ),
                          Text(
                            user.displayName!,
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: 5*MediaQuery.of(context).size.width*0.006,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20,),
                      if(friend)
                        Padding(
                          padding: EdgeInsets.only(bottom: 0),
                          child: GlassContainer(
                            height: 20,
                            color: Colors.black.withOpacity(0.3),
                            blur: 10,
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Amis  ",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Icon(
                                    CupertinoIcons.person_solid,
                                    size: 11,
                                    color: Colors.white.withOpacity(0.8),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      else if (followed)
                        Padding(
                          padding: EdgeInsets.only(bottom: 0),
                          child: GlassContainer(
                            height: 20,
                            color: Colors.black.withOpacity(0.3),
                            blur: 10,
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Vous suit",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  if(widget.recent)
                    IconButton(
                      icon: Icon(CupertinoIcons.clear, color: Colors.black.withOpacity(0.6), size: 17,),
                      onPressed: () {
                        RecentlyViewedManager.instance.removeRecentlyViewedId(widget.id);
                      },
                    )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

