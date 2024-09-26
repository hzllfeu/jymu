import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? id;
  String? displayName;
  String? username;
  int? etat_jymupro;
  List<dynamic>? likes;
  List<dynamic>? trainings;
  List<dynamic>? posts;
  List<dynamic>? comments;
  List<dynamic>? follow;
  List<dynamic>? followed;
  List<dynamic>? tags;
  String? bio;

  static final UserModel _currentUserInstance = UserModel._internal();
  factory UserModel.currentUser() => _currentUserInstance;

  // Constructor pour d'autres utilisateurs
  UserModel();

  UserModel._internal();

  // Récupération des données du currentUser
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

  // Récupération des données pour un utilisateur externe (nouvelle instance)
  Future<void> fetchExternalData(String id) async {
    Map<String, dynamic>? userData = await getProfile(id);
    if (userData != null) {
      _updateFromMap(userData);
    }
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
    etat_jymupro = data['etat_jymupro'];
  }

  // Réinitialisation des données utilisateur
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