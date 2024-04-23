import 'package:flutter/material.dart';
import 'package:jymu/page.dart';
import 'package:jymu/screens/Onboarding/SplashOB.dart';
import 'package:jymu/screens/Questions/Template_question_choix.dart';
import 'package:jymu/screens/home/HomeScreen.dart';
import 'package:jymu/screens/init_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuestionChoix(),
    );
  }
}