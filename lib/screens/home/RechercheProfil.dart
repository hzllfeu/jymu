import 'dart:ui';

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/UserManager.dart';
import 'package:jymu/screens/home/LoadingProfileList.dart';
import 'package:jymu/screens/home/ProfileListComp.dart';

import 'components/TabItem.dart';

class RechercheProfil extends StatefulWidget {
  final String? id;
  final int index;

  RechercheProfil({super.key, required this.id, required this.index});

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
  bool isLoadingBis = true;
  bool hasMore = true;

  final TextEditingController _searchController = TextEditingController();
  late final TabController tabController;
  final ScrollController _scrollController = ScrollController();

  Map<String, Map<String, dynamic>> cachedProfiles = {};


  @override
  void initState() {
    super.initState();
    id = widget.id;
    _fetchDataFuture = _fetchData();
    if (!ownProf) {
      tabController = TabController(length: 3, vsync: this, initialIndex: widget.index);
      isFirstSelected = widget.index == 0;
      isSecondSelected = widget.index == 1;
      isThirdSelected = widget.index == 2;
    } else {
      tabController = TabController(length: 2, vsync: this, initialIndex: widget.index-1);
      isSecondSelected = widget.index == 1;
      isThirdSelected = widget.index == 2;
    }

    _searchController.addListener(() {
      _onSearchChanged();
    });
  }

  Future<void> _onSearchChanged() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final searchResults = await searchProfiles(query);
      if (!mounted) return;
      setState(() {
        displayedProfiles = searchResults;
        hasMore = false;
        _loadMoreProfiles();
      });
    } else {
      setState(() {
        if(isSecondSelected){
          displayedProfiles = (data['followed'] as List<dynamic>).where((userId) => profilesData.containsKey(userId)).cast<String>().toList();
        } else if(isThirdSelected){
          displayedProfiles = (data['follow'] as List<dynamic>).where((userId) => profilesData.containsKey(userId)).cast<String>().toList();
        } else {
          displayedProfiles = data['followed'].toSet().intersection(owndata['followed'].toSet()).toList();
        }
      });
    }
  }

  Future<List<String>> searchProfiles(String query) async {
    List<String> searchResults = [];
    try {
      List<String> allProfiles;
      if(isSecondSelected){
         allProfiles = data['followed'].cast<String>();
      } else if(isThirdSelected){
         allProfiles = data['follow'].cast<String>();
      } else {
        allProfiles = data['followed'].toSet().intersection(owndata['followed'].toSet()).toList();
      }

      for (String userId in allProfiles) {
        var profileData;
        if(cachedProfiles.containsKey(userId)){
          profileData = cachedProfiles[userId];
        } else {
          var profileData = await getProfile(userId);

          String tm = await getProfileImageUrl(userId);

          setState(() {
            profilesData[userId] = profileData ?? {};
            profilesData[userId]?.addAll({'pp': tm});
            if (!ownProf) {
              profilesData[userId]?.addAll({
                'followedbis': owndata['followed'].contains(userId),
                'followbis': owndata['follow'].contains(userId)
              });
            }
            loadingProfiles[userId] = false;
            cachedProfiles[userId] = profileData!;
            isLoading = false;
          });
        }

        if (profileData != null) {
          profilesData[userId] = profileData;
          String displayName = profileData['displayname'] ?? "";
          String username = profileData['username'] ?? "";

          if (displayName.toLowerCase().contains(query.toLowerCase()) ||
              username.toLowerCase().contains(query.toLowerCase())) {
            searchResults.add(userId);
          }
        }
      }
    } catch (e) {
      print('Error in searchProfiles: $e');
    }
    return searchResults;
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
          isLoadingBis = false;
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
      newProfiles = data['followed'].toSet().intersection(owndata['followed'].toSet()).toList().cast<String>();
    } else if (isSecondSelected) {
      newProfiles = followers.cast<String>();
    } else {
      newProfiles = follow.cast<String>();
    }

    final nextProfiles = newProfiles!.skip(displayedProfiles.length).take(itemsPerPage).toList();

    setState(() {
      for (var profileId in nextProfiles) {
        if(!displayedProfiles.contains(profileId)){
          loadingProfiles[profileId] = true;
          _fetchProfileData(profileId);
        }
      }
      displayedProfiles.addAll(nextProfiles);

      isLoading = false;
      hasMore = nextProfiles.length == itemsPerPage;
    });
  }

  Future<void> _fetchProfileData(String profileId) async {
    if (cachedProfiles.containsKey(profileId)){
      if(!profilesData.containsKey(profileId)){
        setState(() {
          profilesData[profileId] = cachedProfiles[profileId]!;
          loadingProfiles[profileId] = false;
          isLoading = false;
        });
        return;
      }
    }
    if (profilesData.containsKey(profileId)){
      if(!cachedProfiles.containsKey(profileId)){
        setState(() {
          cachedProfiles[profileId] = profilesData[profileId]!;
          loadingProfiles[profileId] = false;
          isLoading = false;
        });
        return;
      }
    }

    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(milliseconds: 500));
      var profileData = await getProfile(profileId);

      if (!mounted) return;

      String tm = await getProfileImageUrl(profileId);

      setState(() {
        profilesData[profileId] = profileData ?? {};
        profilesData[profileId]?.addAll({'pp': tm});
        if (!ownProf) {
          profilesData[profileId]?.addAll({
            'followedbis': owndata['followed'].contains(profileId),
            'followbis': owndata['follow'].contains(profileId)
          });
        }
        loadingProfiles[profileId] = false;
        cachedProfiles[profileId] = profileData!;
        isLoading = false;
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
  void dispose() {
    tabController.dispose();
    _scrollController.dispose();

    super.dispose();
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
                  child: Container(
                    height: 33,
                    width: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.arrow_left,
                        size: 22,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                ),
                if(!isLoadingBis)
                  Text(username??"", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: Colors.black.withOpacity(0.7)),),
                if(isLoadingBis)
                  FadeShimmer(width: MediaQuery.of(context).size.width/3, height: 30, radius: 12, highlightColor: Colors.black.withOpacity(0.15), baseColor: Colors.black.withOpacity(0.05),),
                Icon(
                  CupertinoIcons.arrow_left,
                  size: 26,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
          SizedBox(height: 15,),
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
                      if(!ownProf){
                        isFirstSelected = i == 0;
                        isSecondSelected = i == 1;
                        isThirdSelected = i == 2;
                      } else {
                        isSecondSelected = i == 0;
                        isThirdSelected = i == 1;
                      }

                      isLoading = false;
                      hasMore = true;
                      displayedProfiles.clear();
                      _loadMoreProfiles();
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
                    if(!ownProf)
                      Tab(text: 'Commun'),
                    Tab(text: 'Abonnés'),
                    Tab(text: 'Suivis'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if(!isLoading)
            Visibility(
              visible: !isLoading,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 40,
                    child: CupertinoSearchTextField(
                      controller: _searchController,
                      placeholder: "Rechercher",
                      placeholderStyle: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                    ),
                  )
              ),
            ),
          const SizedBox(height: 0),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels > scrollInfo.metrics.maxScrollExtent / 2 && !isLoading) {
                  _loadMoreProfiles();
                }
                return true;
              },
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbColor: WidgetStateProperty.all(Colors.redAccent),
                      trackColor: WidgetStateProperty.all(Colors.redAccent),
                    ),
                    child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        thickness: 4.0,
                        radius: Radius.circular(8),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: displayedProfiles.length + (isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < displayedProfiles.length) {
                              String userId = displayedProfiles[index];
                              if (loadingProfiles[userId] ?? true) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: LoadingProfileList(),
                                );
                              } else {
                                var profileData;
                                if(profilesData.containsKey(userId)){
                                  profileData = profilesData[userId];
                                } else {
                                  profileData = cachedProfiles[userId];
                                }
                                return SizedBox(
                                  height: 80,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 25),
                                    child: ProfileListComp(
                                      urlpp: profileData['pp'] ?? "",
                                      displayname: profileData['displayname'] ?? "Nom inconnu",
                                      username: profileData['username'] ?? 'username',
                                      followed: profileData['followedbis'] ?? false,
                                      follow: profileData['followbis'] ?? false,
                                      id: userId,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return  Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CupertinoActivityIndicator(radius: MediaQuery.of(context).size.width*0.03,),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
    );
  }
}




