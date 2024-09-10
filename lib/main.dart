import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jymu/page.dart';
import 'package:jymu/screens/Connexion/AuthPage.dart';
import 'package:jymu/screens/Connexion/EmailVerif.dart';
import 'package:jymu/screens/Connexion/LoginPage.dart';
import 'package:jymu/screens/Connexion/PfPage.dart';
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/Onboarding/SplashOB.dart';
import 'package:jymu/screens/Onboarding/paiment.dart';
import 'package:jymu/screens/Questions/QuestionObj.dart';
import 'package:jymu/screens/Questions/QuestionPoid.dart';
import 'package:jymu/screens/Questions/QuestionPoidAc.dart';
import 'package:jymu/screens/Questions/QuestionSexe.dart';
import 'package:jymu/screens/Questions/QuestionTaille.dart';
import 'package:jymu/screens/Questions/Template_question_choix.dart';
import 'package:jymu/screens/home/FeedPage.dart';
import 'package:jymu/screens/home/HomeScreen.dart';
import 'package:jymu/screens/init_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart' as timeago_fr;


List<CameraDescription> cameras = [];


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    timeago.setLocaleMessages('fr', timeago_fr.FrMessages());
    final sharedPreferences = await SharedPreferences.getInstance();
    runApp(MyApp());
  } catch (e) {
    print('Erreur lors de l\'initialisation de Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper()
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Erreur: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user != null && !user.emailVerified) {
            return Scaffold(body: EmailVerif());
          } else {
            return InitScreen();
          }
        } else {
          return Scaffold(body: UsernamePage());
        }
      },
    );
  }
}

