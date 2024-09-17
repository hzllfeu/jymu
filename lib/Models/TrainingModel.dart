import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainingModel {
  String? userId;
  String? id;
  String? displayName;
  String? username;
  List<dynamic>? likes;
  List<dynamic>? comments;
  List<dynamic>? tags;
  List<dynamic>? seance;
  String? desc;
  Timestamp? date;
  String? firstImage;
  String? secondImage;

  static final TrainingModel _instance = TrainingModel._internal();
  factory TrainingModel() => _instance;

  TrainingModel._internal();


  Future<void> fetchExternalData(String id) async {

      Map<String, dynamic>? userData = await getTraining(id);
      if (userData != null) {
        _updateFromMap(userData, id);
      }
  }

  Future<void> reloadPostData() async {
    await fetchExternalData(id!);
  }

  void _updateFromMap(Map<String, dynamic> data, String postid) {
    userId = data['id'];
    id = postid;
    displayName = data['displayname'];
    username = data['username'];
    likes = data['likes'];
    comments = data['comments'];
    seance = data['seance'];
    date = data['date'];
    tags = data['tags'];
    desc = data['desc'];
    firstImage = data['firstImage'];
    secondImage = data['secondImage'];

  }

  static TrainingModel get currentUser => _instance;
}

Future<Map<String, dynamic>?> getTraining(String uid) async {
  try {
    if (uid.isNotEmpty) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('trainings').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        print('Aucun profil trouvé pour ce post.');
      }
    } else {
      print('post non trouvé.');
    }
  } catch (e) {
    print('Erreur lors de la récupération du post: $e');
  }
  return null;
}