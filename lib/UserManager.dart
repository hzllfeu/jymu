import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


Future<void> createProfile(User? user) async {
  final userCollection = FirebaseFirestore.instance.collection('users');

  await userCollection.doc(user?.uid).set({
    'id': user?.uid,
    'displayname': user?.displayName,
    'username': user?.displayName,
    'creation': Timestamp.now(),
    'likes': [],
    'comments': [],
    'follow': [],
    'followed': [],
    'tags': ["new"],
    'bio': "",
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

Future<void> addLikeToUser(String userID, String postId, Timestamp timestamp) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'likes': FieldValue.arrayUnion([{'postId': postId, 'timestamp': timestamp}]),
  });
}

Future<void> addCommentToUser(String userID, String commentId, Timestamp timestamp) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  await userRef.update({
    'comments': FieldValue.arrayUnion([{'commentId': commentId, 'timestamp': timestamp}]),
  });
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

Future<void> removeLikeFromUser(String userID, String postId, Timestamp timestamp) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final userSnapshot = await userRef.get();
  List<dynamic> userLikes = userSnapshot['likes'];
  Map<String, dynamic>? likeToRemove;
  for (var like in userLikes) {
    if (like['postId'] == postId) {
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

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.update(userRef, {
      'follow': FieldValue.arrayUnion([targetUserId]),
    });

    transaction.update(targetUserRef, {
      'followed': FieldValue.arrayUnion([userID]),
    });
  });
}

Future<void> unfollowUser(String userID, String targetUserId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
  final targetUserRef = FirebaseFirestore.instance.collection('users').doc(targetUserId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.update(userRef, {
      'follow': FieldValue.arrayRemove([targetUserId]),
    });

    transaction.update(targetUserRef, {
      'followed': FieldValue.arrayRemove([userID]),
    });
  });
}










