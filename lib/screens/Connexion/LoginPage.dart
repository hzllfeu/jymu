import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart'; // Assurez-vous d'avoir Cloud Firestore configuré
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jymu/screens/Connexion/MdpComp.dart';
import '../../Models/UserModel.dart';
import '../init_screen.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver{
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

  bool keybaordopen = false;
  double btmi = 0;

  Future<void> signInUser(String email, String password, BuildContext context) async {
    setState(() {
      fireload = false;
    });
    if(!isValidEmail(email)) {
      error = "Email ou mot de passe incorrect";
      setState(() {
        fireload = true;
      });
      return;
    }
    if(!isValidPassword(password)) {
      error = "Email ou mot de passe incorrect";
      setState(() {
        fireload = true;
      });
      return;
    }

    try {
      // Tentative de connexion avec l'email et le mot de passe fournis
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Si la connexion réussit, l'utilisateur est connecté
      User? user = userCredential.user;
      await UserModel.currentUser().fetchUserData();

      DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(user?.uid);
      String? token = "";
        token = await FirebaseMessaging.instance.getToken();
        await docRef?.update({
          'fcmToken': token,
        });

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InitScreen(),
          ),
        );
        InterMessageManager().showmessage(text: "Connecté");
      } else {
        InterMessageManager().showmessage(text: "Erreur de connexion");
        setState(() {
          fireload = true;
        });
      }

    } catch (e) {

      fireload = true;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            error = "Email ou mot de passe incorrect";
            break;
          case 'wrong-password':
            error = "Email ou mot de passe incorrect";
            break;
          case 'invalid-email':
            error = "Email ou mot de passe incorrect";
            break;
          default:
            error = "Email ou mot de passe incorrect";
        }
      } else {
        error = "Email ou mot de passe incorrect";
      }

    }
  }

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
    WidgetsBinding.instance.addObserver(this);
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
    _emailController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    mdpController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      keybaordopen = bottomInset > 0;
      btmi = bottomInset;
    });
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
            height: MediaQuery.of(context).size.height / 1.6 - btmi/12,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F5F8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(38.0),
                topRight: Radius.circular(38.0),
              ),
            ),
            child: SingleChildScrollView(
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
                              "C'est l'heure de",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 28),
                            ),
                            Row(
                              children: [
                                Text(
                                  "se connecter  ",
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    SizedBox(
                      height: 60,
                      child: Stack(
                        children: [
                          CupertinoTextField(
                            controller: _emailController,
                            padding: EdgeInsets.all(15),
                            onTapOutside: (t){
                              FocusScope.of(context).unfocus();
                            },
                            cursorColor: Colors.redAccent,
                            placeholder: "Entre ton email",
                            keyboardType: TextInputType.emailAddress,
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    SizedBox(
                      height: 60,
                      child: Stack(
                        children: [
                          CupertinoTextField(
                            controller: mdpController,
                            padding: EdgeInsets.all(15),
                            onTapOutside: (t){
                              FocusScope.of(context).unfocus();
                            },
                            cursorColor: Colors.redAccent,
                            obscureText: hidetext,
                            placeholder: "Entre un mot de passe",
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTapUp: (t) {
                            final email = _emailController.text.trim();
                            final password = mdpController.text.trim();
                            signInUser(email, password, context);
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
                    if(!keybaordopen)
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    if(!keybaordopen)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mot de passe oublié ? ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16, color: CupertinoColors.systemGrey),
                        ),
                        SizedBox(width: 5,),
                        GestureDetector(
                          onTapUp: (t) {
                            showCupertinoModalPopup(
                              context: context,
                              barrierColor: Colors.black.withOpacity(0.4),
                              builder: (BuildContext build) {
                                return TweenAnimationBuilder<double>(
                                  duration: Duration(milliseconds: 300),
                                  tween: Tween<double>(begin: 0.0, end: 4.0),
                                  curve: Curves.linear,
                                  builder: (context, value, _) {
                                    return AnimatedOpacity(
                                      duration: Duration(milliseconds: 1000),
                                      opacity: 1.0,
                                      curve: Curves.linear,
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: value, sigmaY: value),
                                        child: CupertinoPopupSurface(
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            height: 420,
                                            child: MdpComp(),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Text(
                            "Appuie ici",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16, color: Colors.deepPurpleAccent),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}
