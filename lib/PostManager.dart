import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jymu/UserManager.dart' as um;
import 'package:jymu/UserManager.dart';
import 'package:uuid/uuid.dart';

import 'Models/UserModel.dart';


Future<void> addPost(User? user, String content) async {
  final uuid = Uuid();
  String trainingId = uuid.v4();
  final postCollection = FirebaseFirestore.instance.collection('posts');

  await postCollection.doc(trainingId).set({
    'id': user?.uid,
    'username': user?.displayName,
    'content': content,
    'postTime': Timestamp.now(),
    'likes': [],
    'comments': [],
  });

  UserModel.currentUser().posts?.add([{'post': trainingId, 'timestamp': Timestamp.now()}]);
  um.addPost(UserModel.currentUser().id!, trainingId, Timestamp.now());
}

QuerySnapshot? lastDocument;

Stream<QuerySnapshot> getPosts() {
  Query query = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('postTime', descending: true)
      .limit(30);

  if (lastDocument != null) {
    query = query.startAfterDocument(lastDocument! as DocumentSnapshot<Object?>);
  }

  return query.snapshots();
}

Stream<QuerySnapshot> getEmptyQuerySnapshot() {
  Query emptySnapshot = FirebaseFirestore.instance
      .collection('test')
      .where('field_that_does_not_exist', isEqualTo: 'value_that_does_not_exist')
      .get() as Query<Object?>;

  return emptySnapshot.snapshots();
}


Future<void> addLike(String postId, String userID) async {
  final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

  final postSnapshot = await postRef.get();

  if (postSnapshot.exists) {
    List<dynamic> postLikes = postSnapshot['likes'];

    if (!postLikes.contains(userID)) {
      await postRef.update({
        'likes': FieldValue.arrayUnion([userID]),
      });

      addLikeToUser(userID, false, postId, Timestamp.now());
    }
  }
}


Future<void> removeLike(String postId, String userID) async {
  final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

  final postSnapshot = await postRef.get();

  if (postSnapshot.exists) {
    List<dynamic> postLikes = postSnapshot['likes'];

    if (postLikes.contains(userID)) {
      await postRef.update({
        'likes': FieldValue.arrayRemove([userID]),
      });

      removeLikeFromUser(userID, false, postId, Timestamp.now());
    }
  }
}


Future<void> addComment(String postId, String username, String comment) async {
  final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
  await postRef.update({
    'comments': FieldValue.arrayUnion([
      {
        'username': username,
        'comment': comment,
        'commentTime': Timestamp.now(),
      }
    ]),
  });
}


