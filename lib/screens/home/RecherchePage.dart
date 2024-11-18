import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/UserManager.dart';
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/home/LoadingLikes.dart';
import 'package:jymu/screens/home/LoadingPost.dart';
import 'package:jymu/screens/home/PostWidget.dart';
import 'package:jymu/screens/home/ProfileListComp.dart';
import 'package:jymu/screens/home/components/LikesComp.dart';
import 'package:jymu/screens/home/components/ModifyAccount.dart';

import 'package:jymu/screens/home/components/NotificationPage.dart';
import 'package:jymu/screens/home/components/PostCard.dart';
import 'package:jymu/screens/home/components/ProfileComp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/CachedData.dart';
import '../../Models/TrainingModel.dart';
import 'LoadingProfile.dart';
import 'TrainingLittle.dart';
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
  late Animation<double> _bounceAnimation;
  Future<void>? _fetchDataFuture;
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isSearching = false;

  Future<void>? data;
  List<String> listPosts = [];
  List<TrainingModel> listtrn = [];
  List<String> _recentlyViewedIds = [];


  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      if(index != selectedIndex){
        selectedIndex = index;
        Haptics.vibrate(HapticsType.medium);
      }
    });
  }

  final FocusNode _focusNode = FocusNode();
  bool _isTextFieldFocused = false;


  @override
  void initState() {
    super.initState();
    data = loadTrainingModels();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.linear))
        .animate(_controller);


    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(() {
      setState(() {
        _isTextFieldFocused = _focusNode.hasFocus;
        Haptics.vibrate(HapticsType.light);
        if (_isTextFieldFocused) {
          _controller.reset();
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }


  void _onSearchChanged() async {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // Requête pour les utilisateurs avec `username` ou `displayname` contenant le texte saisi
      final QuerySnapshot usernameResults = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      final QuerySnapshot displaynameResults = await FirebaseFirestore.instance
          .collection('users')
          .where('displayname', isGreaterThanOrEqualTo: query)
          .where('displayname', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      // Liste temporaire pour stocker les noms des documents
      final List<String> results = [];

      // Ajouter les identifiants des documents trouvés dans `usernameResults`
      for (var doc in usernameResults.docs) {
        results.add(doc.id);
      }

      // Ajouter les identifiants des documents trouvés dans `displaynameResults`, en évitant les doublons
      for (var doc in displaynameResults.docs) {
        if (!results.contains(doc.id)) {
          results.add(doc.id);
        }
      }

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      print("Erreur lors de la recherche : $e");
      setState(() {
        _isSearching = false;
      });
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

  Future<void> loadTrainingModels() async {
    List<String> tmp = await getTrendingPostIdsByScore();
    listPosts.addAll(tmp);
    listPosts.where((id) => id != "default").toSet().toList();

    setState(() {

    });
    for (String s in listPosts) {
      TrainingModel tmp = TrainingModel();

      if (CachedData().trainings.containsKey(s)) {
        tmp = CachedData().trainings[s]!;
      } else {
        await tmp.fetchExternalData(s);
        CachedData().trainings[s] = tmp;
      }

      listtrn.add(tmp);
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      body: Stack(
        children: [
          FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator(radius: 14),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erreur de chargement des trainings'));
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: CustomScrollView(
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () async {
                          listtrn.clear();
                          listPosts.clear();
                          data = loadTrainingModels();
                        },
                        builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
                          final double indicatorHeight = -MediaQuery.of(context).size.height * 0.16; // Hauteur de l'indicateur
                          final double offset =
                              (pulledExtent - indicatorHeight) / 2 + 50;

                          return Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: offset),
                            child: const CupertinoActivityIndicator(),
                          );
                        },
                      ),
                      SliverPadding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                            childAspectRatio: 0.7,
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final training = listtrn[index];
                              return TrainingLittle(trn: training, trending: true, type: "trending",);
                            },
                            childCount: listtrn.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),

          IgnorePointer(
            ignoring: !_isTextFieldFocused,
            child: AnimatedOpacity(
              opacity: _isTextFieldFocused ? 1 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: const Color(0xFFF3F5F8),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 15,),
                    child: _isSearching
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 100),
                        child: CupertinoActivityIndicator(radius: 14),
                      ),
                    )
                        : ValueListenableBuilder<List<String>>(
                      valueListenable: RecentlyViewedManager.instance.recentlyViewedIdsNotifier,
                      builder: (context, recentlyViewedIds, _) {
                        return ListView.builder(
                          itemCount: _searchController.text.trim().isEmpty
                              ? recentlyViewedIds.length
                              : _searchResults.length,
                          itemBuilder: (context, index) {
                            final userId = _searchController.text.trim().isEmpty
                                ? recentlyViewedIds[index]
                                : _searchResults[index];

                            final widget = ProfileListComp(
                              key: ValueKey(userId), // Clé unique pour chaque élément
                              id: userId,
                              recent: _searchController.text.trim().isEmpty, // true si vide
                              search: true,
                            );

                            return index == 0
                                ? Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.09,
                              ),
                              child: widget,
                            )
                                : widget;
                          },
                        );
                      },
                    )
                )
              ),
            ),
          ),

          GlassContainer(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFFF3F5F8).withOpacity(0.85),
            blur: 10,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _bounceAnimation,
                        child: _isTextFieldFocused
                            ? Container(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.015),
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.person_2_fill, color: Colors.redAccent.withOpacity(0.6), size: 18,),
                              const SizedBox(width: 5,),
                              Icon(Icons.keyboard_arrow_down, color: Colors.black.withOpacity(0.6), size: 16,)
                            ],
                          ),
                        )
                            : Container(), // Container vide si non focus
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _isTextFieldFocused
                            ? 10
                            : 0,
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _isTextFieldFocused
                            ? MediaQuery.of(context).size.width * 0.55
                            : MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 15,),
                            const Icon(CupertinoIcons.search, size: 24, color: Colors.redAccent),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: _isTextFieldFocused
                                  ? 5
                                  : 10,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: CupertinoTextField(
                                  focusNode: _focusNode,
                                  controller: _searchController,
                                  cursorColor: Colors.redAccent,
                                  placeholder: _isTextFieldFocused
                                      ? "N'importe quoi · Un profil · Un exercice"
                                      : "N'importe quoi · Un profil · Un exercice",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                  placeholderStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: CupertinoColors.systemGrey.withOpacity(0.6),
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _isTextFieldFocused
                            ? 10
                            : 0,
                      ),
                      ScaleTransition(
                        scale: _bounceAnimation,
                        child: _isTextFieldFocused
                            ? IconButton(
                          icon: Icon(CupertinoIcons.clear_circled, color: Colors.black.withOpacity(0.6), size: 20,),
                          onPressed: () {
                            _focusNode.unfocus();
                            _searchController.clear();
                          },
                        )
                            : Container(), // Container vide si non focus
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({required int index, required IconData icon, required String label}) {
    bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: isSelected ? 0.8 : 0.5,
              child: Icon(
                icon,
                size: 21,
                color: isSelected ? Colors.black.withOpacity(1) : Colors.black.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 2),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: isSelected ? 0.8 : 0.5,
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black.withOpacity(1) : Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget buildProfileContent(BuildContext context) {
    return const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(padding: EdgeInsets.symmetric(horizontal: 25),
            child: CupertinoSearchTextField(),
          ),
          SizedBox(height: 1),
          Expanded(
            child: LoadingLikes(),
          ),
        ]
    );;
  }
}

class RecentlyViewedManager {
  static final RecentlyViewedManager instance = RecentlyViewedManager._internal();
  static const String _key = 'recentlyViewedIds';
  static const int _maxRecentlyViewedIds = 20;
  int len = 0;

  // Utilisation de ValueNotifier pour notifier l'UI
  final ValueNotifier<List<String>> recentlyViewedIdsNotifier = ValueNotifier<List<String>>([]);

  // Constructeur privé pour éviter d'avoir plusieurs instances
  RecentlyViewedManager._internal() {
    _loadRecentlyViewedIds();
  }

  // Charger les IDs des profils récemment consultés depuis SharedPreferences
  Future<void> _loadRecentlyViewedIds() async {
    final prefs = await SharedPreferences.getInstance();
    recentlyViewedIdsNotifier.value = prefs.getStringList(_key) ?? [];
    len = prefs.getStringList(_key)!.length;
  }

  // Ajouter un ID à la liste des récemment consultés
  Future<void> addRecentlyViewedId(String id) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> updatedIds = List.from(recentlyViewedIdsNotifier.value); // Créer une copie de la liste
    if (updatedIds.contains(id)) {
      updatedIds.remove(id); // Retirer l'ID si déjà présent
    }

    updatedIds.insert(0, id); // Ajouter l'ID au début de la liste

    if (updatedIds.length > _maxRecentlyViewedIds) {
      updatedIds = updatedIds.sublist(0, _maxRecentlyViewedIds); // Limiter à _maxRecentlyViewedIds
    }

    recentlyViewedIdsNotifier.value = updatedIds; // Mettre à jour la liste dans ValueNotifier
    len++;
    await prefs.setStringList(_key, updatedIds); // Sauvegarder dans SharedPreferences
  }

  Future<void> removeRecentlyViewedId(String id) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> updatedIds = List.from(recentlyViewedIdsNotifier.value); // Créer une copie de la liste
    updatedIds.remove(id); // Retirer l'ID spécifié de la liste

    len--;

    recentlyViewedIdsNotifier.value = updatedIds; // Mettre à jour la liste dans ValueNotifier
    await prefs.setStringList(_key, updatedIds); // Sauvegarder dans SharedPreferences
  }
}

