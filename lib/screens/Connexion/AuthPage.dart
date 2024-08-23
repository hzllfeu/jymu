import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; // Assurez-vous d'avoir Cloud Firestore configuré
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jymu/screens/Connexion/EmailVerif.dart';
import 'package:jymu/screens/Connexion/LoginPage.dart';
import '../init_screen.dart';

class AuthPage extends StatefulWidget {

  final String username;
  final File profileimage;

  const AuthPage({super.key, required this.username, required this.profileimage});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController mdpController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;
  bool _isEmailAvailable = false;
  bool _hasError = false;
  bool _isFirstImage = true;
  late Timer _timer;
  String error = "";
  bool _hasTyped = false;
  bool hidetext = true;
  bool fireload = true;

  bool isValidEmail(String input) {
    final RegExp regex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(input);
  }

  bool isValidPassword(String input) {
    final RegExp regex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+[\]{};:"|,.<>/?`~\\-]).{8,}$');
    return regex.hasMatch(input);
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    mdpController.addListener(_onPasswordChanged);
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
    _emailController.removeListener(_onEmailChanged);
    mdpController.removeListener(_onPasswordChanged);
    _emailController.dispose();
    mdpController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    if (_emailController.text.trim().isEmpty) return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    setState(() {
      _isLoading = true;
      _hasError = false;
      error = "";
      _hasTyped = true;
    });
    _debounce = Timer(const Duration(seconds: 1), _checkEmailAvailability);
  }

  void _onPasswordChanged() {
    if (mdpController.text.trim().isEmpty) return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    setState(() {
      error = "";
    });
    _debounce = Timer(const Duration(seconds: 1), _checkPasswordStrength);
  }

  Future<void> _checkPasswordStrength() async {
    final password = mdpController.text.trim();

    if (!isValidPassword(password)) {
      setState(() {
        _hasError = true;
        error = "il faut une maj, un nombre et 8 caractères au min";
      });
    } else {
      setState(() {
        _hasError = false;
        error = "";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _checkEmailAvailability() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _isLoading = false;
        _hasTyped = false;
      });
      return;
    }

    if (!isValidEmail(email)) {
      setState(() {
        _hasError = true;
        error = "Format d'email invalide";
        _isEmailAvailable = false;
        _isLoading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: "dummyPassword1234",
      );
      User? user = FirebaseAuth.instance.currentUser;
      await user?.delete();

      setState(() {
        _isEmailAvailable = true;
        _hasError = false;
      });
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        setState(() {
          _isEmailAvailable = false;
          _hasError = true;
          error = "Cet email est déjà utilisé";
        });
      } else {
        setState(() {
          _hasError = true;
          error = "Erreur lors de la vérification de l'email";
          _isEmailAvailable = false;
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _signUp() async {

    setState(() {
      fireload = false;
    });

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: mdpController.text,
      );
      // Upload profile picture to Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_profiles')
          .child('${userCredential.user!.uid}.jpg');

      await ref.putFile(widget.profileimage);

      final profileImageUrl = await ref.getDownloadURL();

      await userCredential.user!.sendEmailVerification();

      // Update user profile
      await userCredential.user!.updateDisplayName(widget.username);
      await userCredential.user!.updatePhotoURL(profileImageUrl);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(body: EmailVerif(),),
        ),
      );
    } catch (e) {
      print('Failed to sign up: $e');
      setState(() {
       fireload = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
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
            height: MediaQuery.of(context).size.height / 1.6,
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
                            "Choisi un moyen",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 28),
                          ),
                          Row(
                            children: [
                              Text(
                                "de connexion  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 28),
                              ),
                              Image.asset(
                                _isFirstImage
                                    ? "assets/images/emoji_phone.png"
                                    : "assets/images/emoji_pc.png",
                                height: 36,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    height: 60,
                    child: Stack(
                      children: [
                        CupertinoTextField(
                          controller: _emailController,
                          padding: EdgeInsets.all(15),
                          cursorColor: Colors.redAccent,
                          placeholder: "Entre ton email",
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
                              _isEmailAvailable
                                  ? CupertinoIcons.check_mark
                                  : CupertinoIcons.clear_thick,
                              color: _isEmailAvailable ? Colors.green : Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    height: 60,
                    child: Stack(
                      children: [
                        CupertinoTextField(
                          controller: mdpController,
                          padding: EdgeInsets.all(15),
                          cursorColor: Colors.redAccent,
                          obscureText: hidetext,
                          placeholder: "Crée un mot de passe",
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey5,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                          Positioned(
                            right: 15,
                            top: 13,
                            child: GestureDetector(
                              onTapUp: (t){
                                setState(() {
                                  hidetext = !hidetext;
                                });
                              },
                              child: Icon(hidetext ? CupertinoIcons.eye_slash : CupertinoIcons.eye, color: CupertinoColors.systemGrey,),
                            )
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
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTapUp: (t) {
                          String username = _emailController.text.trim();
                          if (username.isNotEmpty && !_hasError && !_isLoading && _isEmailAvailable) {
                            _signUp();
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
                              Visibility(
                                visible: fireload,
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
                              Visibility(
                                visible: !fireload,
                                child: CupertinoActivityIndicator(color: Colors.white,),
                              ),
                            ],
                          )
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 50,),
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
    );
  }
}
