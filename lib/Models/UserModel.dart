import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jymu/Models/NotificationService.dart';

class UserModel {
  String? id;
  String? displayName;
  String? username;
  int? etat_jymupro;
  List<dynamic>? likes;
  List<dynamic>? trainings;
  List<dynamic>? posts;
  List<dynamic> notifs = [];
  List<dynamic>? comments;
  List<dynamic>? follow;
  List<dynamic>? followed;
  List<dynamic>? tags;
  Map<String, dynamic>? notifparam;
  String? bio;
  String? fcmToken;
  DocumentReference<Map<String, dynamic>>? docRef;
  Future<void>? notificationsloader;

  static final UserModel _currentUserInstance = UserModel._internal();
  factory UserModel.currentUser() => _currentUserInstance;

  UserModel();

  UserModel._internal();

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      docRef = FirebaseFirestore.instance.collection('users').doc(id);
      Map<String, dynamic>? userData = await getProfile(user.uid);
      if (userData != null) {
          String? token;
          if(!userData.containsKey('fcmToken')){
            token = await FirebaseMessaging.instance.getToken();
            await docRef?.update({
              'fcmToken': token,
            });
            userData['fcmToken'] = token;
          }
          _updateFromMap(userData);

        notificationsloader = StoredNotification().getNotifications(id!);
      }
    } else {
      print("Aucun utilisateur connecté.");
      _resetUserData();
    }
  }

  Future<void> fetchExternalData(String id) async {
    Map<String, dynamic>? userData = await getProfile(id);
    docRef = FirebaseFirestore.instance.collection('users').doc(id);
    String? token;
    if(!userData!.containsKey('fcmToken')){
      token = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance.collection('users').doc(userData['id']).update({
        'fcmToken': token,
      });
      userData['fcmToken'] = token;
    }
    _updateFromMap(userData);
  }

  // Méthode de mise à jour des données
  void _updateFromMap(Map<String, dynamic> data) {
    id = data['id'];
    displayName = data['displayname'];
    username = data['username'];
    likes = data['likes'];
    comments = data['comments'];
    follow = data['follow'];
    followed = data['followed'];
    tags = data['tags'];
    bio = data['bio'];
    trainings = data['trainings'];
    posts = data['posts'];
    notifs = data['notifs'];
    fcmToken = data['fcmToken'];
    notifparam = data['notifparam'];
    etat_jymupro = data['etat_jymupro'];

    if(notifparam!.isEmpty){
      notifparam = {"allnotifs":true, "likenotif": true, "comnotif": true, "abonotif": true}; //TODO a clean
    }
  }

  void _resetUserData() {
    id = null;
    displayName = null;
    username = null;
    likes = [];
    comments = [];
    follow = [];
    followed = [];
    trainings = [];
    posts = [];
    tags = [];
    bio = null;
    etat_jymupro = null;
  }
}

Future<Map<String, dynamic>?> getProfile(String uid) async {
  try {
    if (uid.isNotEmpty) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        print('Aucun profil trouvé pour cet utilisateur.');
      }
    } else {
      print('Utilisateur non trouvé.');
    }
  } catch (e) {
    print('Erreur lors de la récupération du profil: $e');
  }
  return null;
}