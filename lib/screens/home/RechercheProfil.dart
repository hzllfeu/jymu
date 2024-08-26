import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jymu/UserManager.dart';
import 'package:jymu/screens/home/LoadingProfileList.dart';
import 'package:jymu/screens/home/ProfileListComp.dart';

class RechercheProfil extends StatefulWidget {
  final String? id;

  RechercheProfil({super.key, required this.id});

  @override
  State<RechercheProfil> createState() => _RechercheProfilState();
}

class _RechercheProfilState extends State<RechercheProfil> with TickerProviderStateMixin {
  Future<void>? _fetchDataFuture;

  bool isFirstSelected = false;
  bool isSecondSelected = true;
  bool isThirdSelected = false;
  User? user = FirebaseAuth.instance.currentUser;
  String? displayName;
  String? username;
  String? bio = "";
  String? id = "";
  String? profileImageUrl;
  bool followed = false;
  bool isFollowing = false;
  bool friend = false;
  List<dynamic> followers = [];
  List<dynamic> follow = [];
  List<dynamic> likes = [];
  Map<String, dynamic> data = {};
  Map<String, dynamic> owndata = {};
  bool ownProf = false;

  List<String> displayedProfiles = [];
  Map<String, Map<String, dynamic>> profilesData = {};
  Map<String, bool> loadingProfiles = {}; // Suivre l'état de chargement par profil
  int itemsPerPage = 20;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    _fetchDataFuture = _fetchData();
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

        if (!mounted) return;

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

          // Charger les profils initiaux
          _loadMoreProfiles();
        });
      }
    } catch (e) {
      print('Error in _fetchData: $e');
    }
  }

  Future<void> _loadMoreProfiles() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    List<String>? newProfiles;
    if (isFirstSelected) {
      newProfiles = follow.cast<String>(); // Liste des profils suivis
    } else if (isSecondSelected) {
      newProfiles = followers.cast<String>(); // Liste des abonnés
    } else {
      newProfiles = follow.where((id) => followers.contains(id)).cast<String>().toList(); // Liste des amis en commun
    }

    final nextProfiles = newProfiles.skip(displayedProfiles.length).take(itemsPerPage).toList();

    setState(() {
      displayedProfiles.addAll(nextProfiles);
      for (var profileId in nextProfiles) {
        loadingProfiles[profileId] = true; // Marquer les profils comme en cours de chargement
        _fetchProfileData(profileId); // Récupérer les données de chaque profil
      }
      isLoading = false;
      hasMore = nextProfiles.length == itemsPerPage;
    });
  }

  Future<void> _fetchProfileData(String profileId) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      var profileData = await getProfile(profileId);

      if (!mounted) return;

      String tm = await getProfileImageUrl(profileId);

      setState(() {
        profilesData[profileId] = profileData ?? {};
        profilesData[profileId]?.addAll({'pp': tm});
        loadingProfiles[profileId] = false; // Marquer le profil comme chargé
      });
    } catch (e) {
      print('Error fetching profile data for $profileId: $e');
    }
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
        child: buildProfileContent(context),
      ),
    );
  }

  Widget buildProfileContent(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTapUp: (t) {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    CupertinoIcons.arrow_left,
                    size: 26,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                Text(username??"", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black.withOpacity(0.7)),),
                Icon(
                  CupertinoIcons.arrow_left,
                  size: 26,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                      width: double.infinity,
                      height: 70,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 20,),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFirstSelected = true;
                                  isSecondSelected = false;
                                  isThirdSelected = false;
                                  displayedProfiles.clear();
                                  _loadMoreProfiles();
                                });
                              },
                              child: Text(
                                "Commun",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: isFirstSelected ? Colors.redAccent : CupertinoColors.systemGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFirstSelected = false;
                                isSecondSelected = true;
                                isThirdSelected = false;
                                displayedProfiles.clear();
                                _loadMoreProfiles();
                              });
                            },
                            child: Text(
                              "Abonnés",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: isSecondSelected ? Colors.redAccent : CupertinoColors.systemGrey,
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFirstSelected = false;
                                  isSecondSelected = false;
                                  isThirdSelected = true;
                                  displayedProfiles.clear();
                                  _loadMoreProfiles();
                                });
                              },
                              child: Text(
                                "Suivis",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: isThirdSelected ? Colors.redAccent : CupertinoColors.systemGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                        ],
                      )
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    left: isFirstSelected
                        ? MediaQuery.of(context).size.width * 0.022
                        : isSecondSelected
                        ? MediaQuery.of(context).size.width * 0.36
                        : MediaQuery.of(context).size.width * 0.7,
                    top: 50,
                    child: Container(
                      height: 3,
                      width: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color(0xffF14BA9), Colors.redAccent],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: CupertinoSearchTextField(
              placeholder: "Rechercher",
            ),
          ),
          const SizedBox(height: 1),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !isLoading) {
                  _loadMoreProfiles();
                }
                return true;
              },
              child: ListView.builder(
                itemCount: displayedProfiles.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < displayedProfiles.length) {
                    String userId = displayedProfiles[index];
                    if (loadingProfiles[userId] ?? true) {
                      return Padding(padding: EdgeInsets.symmetric(horizontal: 25), child: Expanded(child: LoadingProfileList(),),);
                    } else {
                      var profileData = profilesData[userId] ?? {};
                      return SizedBox(
                        height: 100,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: ProfileListComp(
                              urlpp: profileData['pp'] ?? "",
                              displayname: profileData['displayname'] ?? "Nom inconnu",
                              username: profileData['username'] ?? 'username',
                              followed: false ?? false,
                              friend: false ?? false
                          ),
                        ),
                      );
                    }
                  } else {
                    return Padding(padding: EdgeInsets.symmetric(horizontal: 25), child: Expanded(child: LoadingProfileList(),),);
                  }
                },
              ),
            ),
          ),
        ]
    );
  }
}


