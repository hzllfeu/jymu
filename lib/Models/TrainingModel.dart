import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/Models/CachedData.dart';
import 'package:jymu/Models/TrendingManager.dart';
import 'package:jymu/Models/UserModel.dart';
import 'package:uuid/uuid.dart';

import '../UserManager.dart';
import 'NotificationService.dart';

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

    if (!likes!.contains(userID)) {
      await postRef?.update({
        'likes': FieldValue.arrayUnion([userID]),
      });

      addLikeToUser(userID, true, id!, Timestamp.now());
    }
    likes?.add(userID);
    UserModel targetUser = UserModel();
    if(CachedData().users.containsKey(userId)){
      targetUser = CachedData().users[userId]!;
    } else {
      await targetUser.fetchExternalData(userId!);
      CachedData().users[userId!] = targetUser;
    }

    checkAndUpdateStack(id!);

    sendPushNotification(userId!, "a aimé votre training", "${UserModel.currentUser().username}",  targetUser.fcmToken?? "", true, userID, firstImage!, "like", id!);
  }

  Future<void> addComment(String commentText) async {
    final postRef = docRef;
    String userID = UserModel.currentUser().id!;

    final uuid = Uuid();
    String commentID = uuid.v4();

    Map<String, dynamic> newComment = {
      commentID: [
        commentText,
        Timestamp.now(),
        userID,
        id
      ]
    };

    await postRef?.update({
      'comments': FieldValue.arrayUnion([newComment]),
    });

    comments?.add(newComment);
    if(CachedData().trainings.containsKey(id)){
      CachedData().trainings[id]?.comments?.add(newComment);
    }

    UserModel targetUser = UserModel();
    if(CachedData().users.containsKey(userId)){
      targetUser = CachedData().users[userId]!;
    } else {
      await targetUser.fetchExternalData(userId!);
      CachedData().users[userId!] = targetUser;
    }

    sendPushNotification(userId!,  commentText, "${UserModel.currentUser().username} a commenté", targetUser.fcmToken!, true, userID, firstImage!, "com", id!);

  }

  Future<List<dynamic>> getComment(String id) async {
    List<dynamic> finalList = [];
    for(Map<String, List<dynamic>> e in comments!){
      if(e.containsKey(id)){
        finalList.add(id);
        finalList.add(e.values);
      }
    }
    return finalList;
  }

  Future<void> deleteComment(String commentId) async {
    final postRef = docRef;

    if (comments != null && comments!.isNotEmpty) {
      Map<String, dynamic>? commentToDelete;
      for (var comment in comments!) {
        if (comment.containsKey(commentId)) {
          commentToDelete = comment;
          break;
        }
      }

      if (commentToDelete != null) {
        await postRef?.update({
          'comments': FieldValue.arrayRemove([commentToDelete]),
        });

        comments?.remove(commentToDelete);
        if(CachedData().trainings.containsKey(id)){
          CachedData().trainings[id]?.comments?.remove(commentToDelete);
        }
      }
    }
  }

  Future<void> deletePost() async {
    final postRef = docRef;

    await postRef?.delete().then((_) async {
      if(CachedData().trainings.containsKey(id)){
        CachedData().trainings.remove(id);
      }
      if(CachedData().users[UserModel.currentUser().id]!.trainings!.contains(id)){
        CachedData().users[UserModel.currentUser().id]!.trainings!.remove(id);
      }
      await removeTraining(UserModel.currentUser().id!, id!);
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

  Future<void> reportComment(String reason, String commentID, String comment) async {
    final uuid = Uuid();
    final trainingCollection = FirebaseFirestore.instance.collection('commentReports');

    String trainingId = uuid.v4();

    await trainingCollection.doc(trainingId).set({
      'trainingId': id,
      'ownerId': userId,
      'displayname': displayName,
      'username': username,
      'date': Timestamp.now(),
      'reason': reason,
      'reporterId': UserModel.currentUser().id,
      'commentId': commentID,
      'comment': comment
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

Future<List<String>> getTrainingsForUser(int n, List<String> excluded) async {
  List<String> documentIds = [];
  List<String>? suivis = UserModel.currentUser().follow!.cast<String>();

  DateTime todayStart = DateTime.now();
  DateTime today = DateTime(todayStart.year, todayStart.month, todayStart.day);

  if (suivis == null || suivis.isEmpty) {
    return documentIds;
  }

  Query query = FirebaseFirestore.instance
      .collection('trainings')
      .where('id', whereIn: suivis) // Filtrer par utilisateurs suivis
      .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(today)) // Documents datant d'aujourd'hui
      .orderBy('date', descending: true) // Trier par plus récent
      .limit(n * 2); // On prend plus de résultats pour compenser le filtrage manuel

  QuerySnapshot querySnapshot = await query.get();

  documentIds = querySnapshot.docs
      .map((doc) => doc.id)
      .where((id) => id != "default" && !excluded.contains(id)) // Exclure les IDs non souhaités
      .take(n) // Limiter à `n` résultats
      .toList();

  return documentIds;
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

Future<List<String>> getTrendingPostIdsByScore() async {
  final firestore = FirebaseFirestore.instance;

  try {
    DocumentSnapshot trendingDoc = await firestore.collection('trending').doc('trendings').get();

    if (!trendingDoc.exists || trendingDoc.data() == null) {
      print("Document 'trendings' not found or has no data.");
      return [];
    }

    Map<String, dynamic> postsMap = (trendingDoc.data() as Map<String, dynamic>)['posts'] ?? {};

    List<String> sortedPostIds = postsMap.keys.toList()
      ..sort((a, b) => (postsMap[b]['score'] as num).compareTo(postsMap[a]['score'] as num));

    return sortedPostIds;
  } catch (e) {
    print("Erreur lors de la récupération des posts trending: $e");
    return [];
  }
}