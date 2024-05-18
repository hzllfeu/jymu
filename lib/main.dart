import 'package:flutter/material.dart';
import 'package:jymu/page.dart';
import 'package:jymu/screens/Onboarding/SplashOB.dart';
import 'package:jymu/screens/Onboarding/paiment.dart';
import 'package:jymu/screens/Questions/Template_question_choix.dart';
import 'package:jymu/screens/home/HomeScreen.dart';
import 'package:jymu/screens/init_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Paiement(),
    );
  }
}