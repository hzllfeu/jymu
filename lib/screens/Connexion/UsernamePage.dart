import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart'; // Assurez-vous d'avoir Cloud Firestore configuré
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jymu/screens/Connexion/PfPage.dart';
import 'package:haptic_feedback/haptic_feedback.dart';


import 'LoginPage.dart';

class UsernamePage extends StatefulWidget {
  @override
  _UsernamePageState createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final TextEditingController _usernameController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;
  bool _isUsernameAvailable = false;
  bool _hasError = false;
  bool _isFirstImage = true;
  late Timer _timer;
  String error = "";
  bool _hasTyped = false;

  bool isValidUsername(String input) {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9._-]{3,22}$');
    return regex.hasMatch(input);
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _isFirstImage = !_isFirstImage;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _timer.cancel();
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();
    super.dispose();
  }

  void _onUsernameChanged() {
    if(_usernameController.text.trim().isEmpty)
      return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    setState(() {
      _isLoading = true; // Afficher l'indicateur de chargement immédiatement
      _hasError = false; // Réinitialiser les erreurs
      error = "";
      _hasTyped = true;
    });
    _debounce = Timer(const Duration(seconds: 1), _checkUsernameAvailability);
  }

  Future<void> _checkUsernameAvailability() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      setState(() {
        _isLoading = false;
        _hasTyped = false;
      });
      return;
    }

    if(!isValidUsername(username)){
      setState(() {
        _hasError = true;
        error = "Il ne doit pas avoir de caractéres spéciaux";
        _isUsernameAvailable = false;
        _isLoading = false;
      });
      return;
    }
    try {
      // Remplacez ceci par la méthode de vérification de votre nom d'utilisateur
      // Exemple avec Firestore pour vérifier l'existence d'un nom d'utilisateur
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      setState(() {
        _isUsernameAvailable = querySnapshot.docs.isEmpty; // Disponible si aucun document n'est trouvé
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        error = "Ce nom est déja pris";
        _isUsernameAvailable = false;
      });
    } finally {
      setState(() {
        _isLoading = false; // Masquer l'indicateur de chargement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.redAccent,
              Colors.deepOrange,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height / 1.9,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F5F8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38.0),
                  topRight: Radius.circular(38.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Trouve toi un",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 28),
                            ),
                            Row(
                              children: [
                                Text(
                                  "nom d'utilisateur ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700, fontSize: 28),
                                ),
                                Image.asset(
                                  _isFirstImage
                                      ? "assets/images/emoji_menuh.png"
                                      : "assets/images/emoji_menuf.png",
                                  height: 38,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    SizedBox(
                      height: 60,
                      child: Stack(
                        children: [
                          CupertinoTextField(
                            controller: _usernameController,
                            padding: EdgeInsets.all(15),
                            cursorColor: Colors.redAccent,
                            placeholder: "Taper un nom d'utilisateur",
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey5,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          if (_isLoading)
                            Positioned(
                              right: 10,
                              top: 13,
                              child: CupertinoActivityIndicator(),
                            ),
                          if (!_isLoading && _hasTyped)
                            Positioned(
                              right: 10,
                              top: 13,
                              child: Icon(
                                _isUsernameAvailable
                                    ? CupertinoIcons.check_mark
                                    : CupertinoIcons.clear_thick,
                                color: _isUsernameAvailable ? Colors.green : Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            error,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.redAccent),
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTapUp: (t) {
                            String username = _usernameController.text.trim();
                            if (username.isNotEmpty && !_hasError) {
                              Haptics.vibrate(HapticsType.light);
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        Scaffold(body: PfPage(username: username),)
                                ),
                              );
                            } else {
                              Haptics.vibrate(HapticsType.error);
                            }
                          },
                          child: Container(
                            height: 70,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.redAccent,
                                  Colors.deepOrange,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffF14BA9).withOpacity(0.5),
                                  spreadRadius: 4,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Suivant",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                                ),
                                SizedBox(width: 15,),
                                Icon(CupertinoIcons.arrow_right, color: Colors.white, size: 20,)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tu as deja un compte ? ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16, color: CupertinoColors.systemGrey),
                        ),
                        SizedBox(width: 5,),
                        GestureDetector(
                          onTapUp: (t){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(body: LoginPage(),),
                              ),
                            );
                          },
                          child: Text(
                            "Se connecter",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16, color: Colors.deepPurpleAccent),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
