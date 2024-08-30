import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jymu/UserManager.dart';


Future<void> addPost(User? user, String content) async {
  final postCollection = FirebaseFirestore.instance.collection('posts');

  await postCollection.add({
    'id': user?.uid,
    'username': user?.displayName,
    'content': content,
    'postTime': Timestamp.now(),
    'likes': [],
    'comments': [],
  });
}

QuerySnapshot? lastDocument;

Stream<QuerySnapshot> getPosts() {
  Query query = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('postTime', descending: true)
      .limit(10);

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

      addLikeToUser(userID, postId, Timestamp.now());
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

      removeLikeFromUser(userID, postId, Timestamp.now());
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


