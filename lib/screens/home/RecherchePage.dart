import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jymu/UserManager.dart';
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/home/LoadingLikes.dart';
import 'package:jymu/screens/home/LoadingPost.dart';
import 'package:jymu/screens/home/PostWidget.dart';
import 'package:jymu/screens/home/components/LikesComp.dart';
import 'package:jymu/screens/home/components/ModifyAccount.dart';

import 'package:jymu/screens/home/components/NotificationPage.dart';
import 'package:jymu/screens/home/components/PostCard.dart';
import 'package:jymu/screens/home/components/ProfileComp.dart';

import 'LoadingProfile.dart';
import 'components/PostsComp.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class RecherchePage extends StatefulWidget {
  final String id;

  RecherchePage({super.key, required this.id});

  @override
  State<RecherchePage> createState() => _RecherchePageState();
}

class _RecherchePageState extends State<RecherchePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;
  Future<void>? _fetchDataFuture;


  bool isFirstSelected = true;
  bool isSecondSelected = false;
  bool isThirdSelected = false;
  bool _isLoading = true;
  User? user = FirebaseAuth.instance.currentUser;
  String? displayName;
  String? username;
  String? bio = "";
  String? id = "";
  String? profileImageUrl;
  bool followed = false;
  bool isFollowing = false;
  bool friend = false;
  late List<dynamic> followers;
  late List<dynamic> follow;
  late List<dynamic> likes;
  late Map<String, dynamic> data;
  late Map<String, dynamic> owndata;
  bool ownProf = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    id = widget.id;

    _fetchDataFuture = _fetchData();

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _colorAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  void handleFollow() {
    setState(() {
      followed = true;
      if (isFollowing) {
        friend = true;
      }
      _controller.reset();
      _controller.forward();
    });
  }

  Future<void> handleUnFollow() async {
    await unfollowUser(FirebaseAuth.instance.currentUser!.uid, id!);
    setState(() {
      followed = false;
      friend = false;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      if (id != null) {
        if (id == FirebaseAuth.instance.currentUser?.uid) {
          ownProf = true;
        }
        data = (await getProfile(id!))!;
        if (!ownProf) {
          owndata = (await getProfile(FirebaseAuth.instance.currentUser!.uid))!;
        }

        if (!mounted) return;  // Vérifiez si le widget est monté

        setState(() {
          _fetchProfileImageUrl();
          followers = data['followed'];
          likes = data['likes'];
          username = data['username'];
          displayName = data['displayname'];
          follow = data['follow'];
          bio = data['bio'];

          if (!ownProf && followers.contains(FirebaseAuth.instance.currentUser?.uid)) {
            followed = true;
          }
          if (!ownProf && follow.contains(FirebaseAuth.instance.currentUser?.uid)) {
            isFollowing = true;
          }
          if (!ownProf && followed && isFollowing) {
            friend = true;
          }

          if (!ownProf) {

            if (isFollowing) {
              _controller.forward();
            }
            if (friend) {
              _controller.forward();
            }
          }
        });
      }
    } catch (e) {
      print('Error in _fetchData: $e');
    }
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
    if (id != "") {
      String tmp = await getProfileImageUrl(id!);

      if (!mounted) return;
      setState(() {
        profileImageUrl = tmp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F8),
      body: SafeArea(
        child: FutureBuilder(
          future: _fetchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 25),
                      child: CupertinoSearchTextField(),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: LoadingLikes(),
                    ),
                  ]
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur de chargement du profil'));
            } else {
              return buildProfileContent(context);
            }
          },
        ),
      ),
    );
  }

  Widget buildProfileContent(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(padding: EdgeInsets.symmetric(horizontal: 25),
            child: CupertinoSearchTextField(),
          ),
          const SizedBox(height: 1),
          Expanded(
            child: LoadingLikes(),
          ),
        ]
    );;
  }
}

