import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? id;
  String? displayName;
  String? username;
  List<dynamic>? likes;
  List<dynamic>? comments;
  List<dynamic>? follow;
  List<dynamic>? followed;
  List<dynamic>? tags;
  String? bio;

  static final UserModel _instance = UserModel._internal();
  factory UserModel() => _instance;

  UserModel._internal();

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Map<String, dynamic>? userData = await getProfile(user.uid);
      if (userData != null) {
        _updateFromMap(userData);
      }
    } else {
      print("Aucun utilisateur connecté.");
      _resetUserData();
    }
  }

  Future<void> fetchExternalData(String id) async {

      Map<String, dynamic>? userData = await getProfile(id);
      if (userData != null) {
        _updateFromMap(userData);
      }
  }

  Future<void> reloadUserData() async {
    await fetchUserData();
  }

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
  }

  void _resetUserData() {
    id = null;
    displayName = null;
    username = null;
    likes = [];
    comments = [];
    follow = [];
    followed = [];
    tags = [];
    bio = null;
  }

  static UserModel get currentUser => _instance;
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