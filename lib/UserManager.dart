import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jymu/Models/NotificationService.dart';

import 'Models/CachedData.dart';
import 'Models/UserModel.dart';


Future<void> createProfile(User? user) async {
  final userCollection = FirebaseFirestore.instance.collection('users');
  String? token = await FirebaseMessaging.instance.getToken();

  await userCollection.doc(user?.uid).set({
    'id': user?.uid,
    'displayname': user?.displayName,
    'username': user?.displayName,
    'creation': Timestamp.now(),
    'likes': [],
    'trainings': [],
    'posts': [],
    'comments': [],
    'follow': [],
    'followed': [],
    'notifs': [],
    'notifparam': {"allnotifs":true, "likenotif": true, "comnotif": true, "abonotif": true},
    'tags': ["new"],
    'bio': "",
    'fcmToken': token,
    'etat_jymupro': 0
  });
}

Future<Map<String, dynamic>?> getProfile(String uid) async {
  try {

    if (uid != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> firestoreData = userDoc.data() as Map<String, dynamic>;

        return firestoreData;
      } else {
        print('Aucun profil trouvé dans Firestore pour cet utilisateur.');
      }
    } else {
      print('Utilisateur non authentifié ou non trouvé.');
    }
  } catch (e) {
    print('Erreur lors de la récupération du profil: $e');
  }

  return null;
}


Future<String?> getUsername(String userID) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final snapshot = await userRef.get();
  if (snapshot.exists && snapshot.data() != null) {
    return snapshot.data()!['username'] as String?;
  }
  return null;
}

Future<void> setUsername(String userID, String username) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'username': username,
  });
}

Future<String?> getBio(String userID) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final snapshot = await userRef.get();
  if (snapshot.exists && snapshot.data() != null) {
    return snapshot.data()!['bio'] as String?;
  }
  return null;
}

Future<void> setBio(String userID, String username) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'bio': username,
  });
}

Future<String?> getDisplayName(String userID) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final snapshot = await userRef.get();
  if (snapshot.exists && snapshot.data() != null) {
    return snapshot.data()!['displayname'] as String?;
  }
  return null;
}

Future<void> setDisplayName(String userID, String displayName) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'displayname': displayName,
  });

  // Mettre à jour le displayName dans FirebaseAuth également
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null && user.uid == userID) {
    await user.updateDisplayName(displayName);
  }
}

Future<List<dynamic>> getLikes(String userID) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final snapshot = await userRef.get();
  if (snapshot.exists && snapshot.data() != null) {
    return snapshot.data()!['likes'] as List<dynamic>? ?? [];
  }
  return [];
}

Future<List<dynamic>> getComments(String userID) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final snapshot = await userRef.get();
  if (snapshot.exists && snapshot.data() != null) {
    return snapshot.data()!['comments'] as List<dynamic>? ?? [];
  }
  return [];
}

Future<List<dynamic>> getFollow(String userID) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final snapshot = await userRef.get();
  if (snapshot.exists && snapshot.data() != null) {
    return snapshot.data()!['follow'] as List<dynamic>? ?? [];
  }
  return [];
}

Future<List<dynamic>> getFollowed(String userID) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final snapshot = await userRef.get();
  if (snapshot.exists && snapshot.data() != null) {
    return snapshot.data()!['followed'] as List<dynamic>? ?? [];
  }
  return [];
}

Future<void> setFollowed(String userID, List<dynamic> followed) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'followed': followed,
  });
}
Future<void> setFollow(String userID, List<dynamic> follow) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'follow': follow,
  });
}

Future<void> setComments(String userID, List<dynamic> comments) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'comments': comments,
  });
}

Future<void> setLikes(String userID, List<dynamic> likes) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'likes': likes,
  });
}

Future<void> addLikeToUser(String userID, bool trn, String postId, Timestamp timestamp) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'likes': FieldValue.arrayUnion([{trn ? 'trnId' : 'postId': postId, 'timestamp': timestamp}]),
  });
}

Future<void> addCommentToUser(String userID, String commentId, Timestamp timestamp) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'comments': FieldValue.arrayUnion([{'commentId': commentId, 'timestamp': timestamp}]),
  });
}

Future<void> addTraining(String userID, String trainingID, Timestamp timestamp) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'trainings': FieldValue.arrayUnion([{'training': trainingID, 'timestamp': timestamp}]),
  });
}

Future<void> addPost(String userID, String postID, Timestamp timestamp) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'posts': FieldValue.arrayUnion([{'post': postID, 'timestamp': timestamp}]),
  });
}

Future<void> removeTraining(String userID, String postId) async { //TODO: optimiser par rapport aux nombre d'appels
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final userSnapshot = await userRef.get();
  List<dynamic> userLikes = userSnapshot['trainings'];
  Map<String, dynamic>? likeToRemove;
  for (var like in userLikes) {
    if (like['training'] == postId) {
      likeToRemove = like;
      break;
    }
  }

  if (likeToRemove != null) {
    await userRef.update({
      'trainings': FieldValue.arrayRemove([likeToRemove]),
    });
  }
}

Future<void> removePost(String userID, String postId, Timestamp timestamp) async { //TODO: optimiser par rapport aux nombre d'appels
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final userSnapshot = await userRef.get();
  List<dynamic> userLikes = userSnapshot['posts'];
  Map<String, dynamic>? likeToRemove;
  for (var like in userLikes) {
    if (like['post'] == postId) {
      likeToRemove = like;
      break;
    }
  }

  if (likeToRemove != null) {
    await userRef.update({
      'posts': FieldValue.arrayRemove([likeToRemove]),
    });
  }
}

Future<void> addTagToUser(String userID, String tag) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'tags': FieldValue.arrayUnion([tag]),
  });
}

Future<void> addFollowToUser(String userID, String followUserId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'follow': FieldValue.arrayUnion([followUserId]),
  });
}

Future<void> addFollowedToUser(String userID, String followedUserId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'followed': FieldValue.arrayUnion([followedUserId]),
  });
}

Future<void> removeLikeFromUser(String userID, bool trn, String postId, Timestamp timestamp) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final userSnapshot = await userRef.get();
  List<dynamic> userLikes = userSnapshot['likes'];
  Map<String, dynamic>? likeToRemove;
  for (var like in userLikes) {
    if (like[trn ? 'trnId': 'postId'] == postId) {
      likeToRemove = like;
      break;
    }
  }

  if (likeToRemove != null) {
    await userRef.update({
      'likes': FieldValue.arrayRemove([likeToRemove]),
    });
  }
}

Future<void> removeCommentFromUser(String userID, String commentId, Timestamp timestamp) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'comments': FieldValue.arrayRemove([{'commentId': commentId, 'timestamp': timestamp}]),
  });
}

Future<void> removeTagFromUser(String userID, String tag) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'tags': FieldValue.arrayRemove([tag]),
  });
}

Future<void> setTagFromUser(String userID, List<dynamic> tag) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'tags': tag,
  });
}

Future<void> removeFollowFromUser(String userID, String followUserId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'follow': FieldValue.arrayRemove([followUserId]),
  });
}

Future<void> removeFollowedFromUser(String userID, String followedUserId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'followed': FieldValue.arrayRemove([followedUserId]),
  });
}

Future<void> followUser(String userID, String targetUserId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final targetUserRef = FirebaseFirestore.instance.collection('users').doc(targetUserId);

  UserModel targetUser = UserModel();
  if(CachedData().users.containsKey(targetUserId)){
    targetUser = CachedData().users[targetUserId]!;
  } else {
    await targetUser.fetchExternalData(targetUserId!);
    CachedData().users[targetUserId!] = targetUser;
  }

  if(targetUser.fcmToken != null){
    if(targetUser.ftoken != null){
      targetUser.ftoken!.add(UserModel.currentUser().fcmToken);
    } else {
      targetUser.ftoken = [UserModel.currentUser().fcmToken];
    }
  }


  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.update(userRef, {
      'follow': FieldValue.arrayUnion([targetUserId]),
    });

    transaction.update(targetUserRef, {
      'followed': FieldValue.arrayUnion([userID]),
    });

    transaction.update(targetUserRef, {
      'followerstokens': FieldValue.arrayUnion([UserModel.currentUser().fcmToken]),
    });
  });

  sendPushNotification(targetUserId, "a commencer à vous suivre", "${UserModel.currentUser().username}",  targetUser.fcmToken!, true, userID, "", "abo", "");
}

Future<void> unfollowUser(String userID, String targetUserId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final targetUserRef = FirebaseFirestore.instance.collection('users').doc(targetUserId);

  UserModel targetUser = UserModel();
  if(CachedData().users.containsKey(targetUserId)){
    targetUser = CachedData().users[targetUserId]!;
  } else {
    await targetUser.fetchExternalData(targetUserId!);
    CachedData().users[targetUserId!] = targetUser;
  }

  if(targetUser.ftoken != null){
    targetUser.ftoken!.remove(UserModel.currentUser().fcmToken);
  }

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.update(userRef, {
      'follow': FieldValue.arrayRemove([targetUserId]),
    });

    transaction.update(targetUserRef, {
      'followed': FieldValue.arrayRemove([userID]),
    });

    transaction.update(targetUserRef, {
      'followerstokens': FieldValue.arrayRemove([UserModel.currentUser().fcmToken]),
    });
  });
}

Future<void> setEtatJymuPro(String userID, int etat) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);

  try {
    await userRef.update({
      'etat_jymupro': etat,
    });
    print("etat_jymupro mis à jour avec succès à $etat.");
  } catch (e) {
    print("Erreur lors de la mise à jour de etat_jymupro : $e");
  }
}








