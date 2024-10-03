import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/Models/CachedData.dart';
import 'package:jymu/Models/UserModel.dart';
import 'package:uuid/uuid.dart';

import '../UserManager.dart';

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
  DocumentReference<Map<String, dynamic>>? docRef;

  TrainingModel();


  Future<void> fetchExternalData(String id) async {

      Map<String, dynamic>? userData = await getTraining(id);
      if (userData != null) {
        _updateFromMap(userData, id);
        docRef = FirebaseFirestore.instance.collection('trainings').doc(id);
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

  Future<void> addLike() async {
    final postRef = docRef;
    String userID = UserModel.currentUser().id!;

    final postSnapshot = await postRef?.get();

    if (postSnapshot!.exists) {
      List<dynamic> postLikes = postSnapshot['likes'];

      if (!postLikes.contains(userID)) {
        await postRef?.update({
          'likes': FieldValue.arrayUnion([userID]),
        });

        addLikeToUser(userID, true, id!, Timestamp.now());
      }
    }
    likes?.add(userID);
  }

  Future<void> deletePost() async {
    final postRef = docRef;

    await postRef?.delete().then((_) {
      if(CachedData().trainings.containsKey(id)){
        CachedData().trainings.remove(id);
      }
      if(CachedData().users[UserModel.currentUser().id]!.trainings!.contains(id)){
        CachedData().users[UserModel.currentUser().id]!.trainings!.remove(id);
      }
      UserModel.currentUser().trainings?.remove(id);
      Haptics.vibrate(HapticsType.success);
    }).catchError((error) {
    });
  }

  Future<void> report(String reason) async {
    final uuid = Uuid();
    final trainingCollection = FirebaseFirestore.instance.collection('reports');

    String trainingId = uuid.v4();

    await trainingCollection.doc(trainingId).set({
      'trainingId': id,
      'ownerId': userId,
      'displayname': displayName,
      'username': username,
      'date': Timestamp.now(),
      'reason': reason,
      'reporterId': UserModel.currentUser().id,
    });
  }

  Future<void> removeLike() async {
    final postRef = docRef;
    String userID = UserModel.currentUser().id!;
    final postSnapshot = await postRef?.get();

    if (postSnapshot!.exists) {
      List<dynamic> postLikes = postSnapshot['likes'];

      if (postLikes.contains(userID)) {
        await postRef?.update({
          'likes': FieldValue.arrayRemove([userID]),
        });

        removeLikeFromUser(userID, true, id!, Timestamp.now());
      }
    }
    likes?.remove(userID);
  }
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

Future<List<String>> getTrainingsForUser(String targetID, int n, List<String> excluded) async {
  List<String> documentIds = [];

  if (excluded.length > 10) {
    List<List<String>> excludedChunks = [];

    for (var i = 0; i < excluded.length; i += 10) {
      excludedChunks.add(excluded.sublist(i, i + 10 > excluded.length ? excluded.length : i + 10));
    }

    for (var chunk in excludedChunks) {
      Query query = FirebaseFirestore.instance
          .collection('trainings')
          .where(FieldPath.documentId, whereNotIn: chunk)
          .limit(n);

      QuerySnapshot querySnapshot = await query.get();

      documentIds.addAll(
          querySnapshot.docs
              .map((doc) => doc.id)
              .where((id) => id != "default")
              .toList()
      );

      if (documentIds.length >= n) break; // Stopper si on a assez de documents
    }
  } else if(excluded.isNotEmpty){
    Query query = FirebaseFirestore.instance
        .collection('trainings')
        .where(FieldPath.documentId, whereNotIn: excluded)
        .limit(n);

    QuerySnapshot querySnapshot = await query.get();

    documentIds = querySnapshot.docs
        .map((doc) => doc.id)
        .where((id) => id != "default")
        .toList();
  } else {
    Query query = FirebaseFirestore.instance
        .collection('trainings')
        .limit(n);

    QuerySnapshot querySnapshot = await query.get();

    documentIds = querySnapshot.docs
        .map((doc) => doc.id)
        .where((id) => id != "default")
        .toList();
  }

  return documentIds.take(n).toList();
}


String formatDate(DateTime date) {
  DateTime now = DateTime.now();

  List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  String day = date.day.toString();
  String monthAbbr = months[date.month - 1];
  String formattedDate = day;

  if (date.month != now.month || date.year != now.year) {
    formattedDate += ', $monthAbbr';

    if (date.year != now.year) {
      formattedDate += ' ${date.year}';
    }
  }

  return formattedDate;
}