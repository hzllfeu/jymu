import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jymu/page.dart';
import 'package:jymu/screens/Connexion/AuthPage.dart';
import 'package:jymu/screens/Connexion/EmailVerif.dart';
import 'package:jymu/screens/Connexion/LoginPage.dart';
import 'package:jymu/screens/Connexion/PfPage.dart';
import 'package:jymu/screens/Connexion/UsernamePage.dart';
import 'package:jymu/screens/init_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/NotificationService.dart';
import 'Models/UserModel.dart';
import 'firebase_options.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart' as timeago_fr;
import 'package:jymu/Alexis/get_exercise.dart';


List<CameraDescription> cameras = [];


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();


  try {

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await NotificationController.initializeLocalNotifications();
    await NotificationController.initializeIsolateReceivePort();

    timeago.setLocaleMessages('fr', CustomFrenchMessages());
    final sharedPreferences = await SharedPreferences.getInstance();
    runApp(MyApp());
  } catch (e) {
    print('Erreur lors de l\'initialisation de Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

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

class CustomFrenchMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => 'dans';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'maintenant';
  @override
  String aboutAMinute(int minutes) => 'une minute';
  @override
  String minutes(int minutes) => '$minutes minutes';
  @override
  String aboutAnHour(int minutes) => 'une heure';
  @override
  String hours(int hours) => '$hours heures';
  @override
  String aDay(int hours) => 'un jour';
  @override
  String days(int days) => '$days jours';
  @override
  String aboutAMonth(int days) => 'un mois';
  @override
  String months(int months) => '$months mois';
  @override
  String aboutAYear(int year) => 'un an';
  @override
  String years(int years) => '$years ans';
  @override
  String wordSeparator() => '';
}

