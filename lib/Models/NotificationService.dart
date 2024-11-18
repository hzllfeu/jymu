import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jymu/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';


import '../main.dart';
import '../screens/init_screen.dart';
import 'CachedData.dart';

class StoredNotification {

  static final StoredNotification _instance = StoredNotification._internal();

  int nlike = 0;
  int nabo = 0;
  int ncom = 0;
  List<NotificationModel> notifs = [];
  bool tday = false;

  bool tdaypostnotif1 = false;
  bool tdaypostnotif2 = false;
  bool tdaypostnotif3 = false;

  bool called = false;

  Future<void> getNotifications(String userId) async {
    if(called) {
      return;
    }
    called = true;

    if (UserModel.currentUser() != null){
      List<NotificationModel> allNotifs = UserModel.currentUser().notifs!
          .map((notif) => NotificationModel.fromMap(notif))
          .toList();

      Set<String> seenIds = {};

      for (var notif in allNotifs) {
        if (!seenIds.contains(notif.id)) {
          seenIds.add(notif.id);
          notifs.add(notif);
        }
      }

      List<String> tdypostid = getPostIdsForToday(UserModel.currentUser().trainings!);

      for(NotificationModel n in notifs){
        if(n.type == "abo"){
          nabo++;
        }
        if(n.type == "like"){
          nlike++;
          for(int i = 0; i < tdypostid.length ; i++){
            if(n.postid == tdypostid[i]){
              if(i == 0){
                tdaypostnotif1 = true;
              } if(i == 1){
                tdaypostnotif2 = true;
              } if(i == 2){
                tdaypostnotif3 = true;
              }
            }
          }
        }
        if(n.type == "com"){
          ncom++;
          for(int i = 0; i < tdypostid.length ; i++){
            if(n.postid == tdypostid[i]){
              if(i == 0){
                tdaypostnotif1 = true;
              } if(i == 1){
                tdaypostnotif2 = true;
              } if(i == 2){
                tdaypostnotif3 = true;
              }
            }
          }
        }
      }

      List<NotificationModel> flist = await NotificationDatabase().getAll();

      for (var notif in notifs) {
        bool alreadyExists = flist.any((existingNotif) => existingNotif.id == notif.id);
        if (!alreadyExists) {
          await NotificationDatabase().insertNotification(notif);
        }
      }

      if (notifs.isNotEmpty) {
        await UserModel.currentUser().docRef?.update({
          'notifs': [],
        });
      }

      Set<String> existingIds = flist.map((notif) => notif.id).toSet();
      notifs.removeWhere((notif) => existingIds.contains(notif.id));

      notifs.addAll(flist);
    } else {
      notifs = [];
    }
  }

  StoredNotification._internal();

  factory StoredNotification() {
    return _instance;
  }
}

class NotificationModel {
  final String title;
  final String message;
  final String id;
  final Timestamp timestamp;
  final bool seen;
  final bool ext;
  final String extid;
  final String actionid;
  final String type;
  final String postid;


  NotificationModel({
    required this.title,
    required this.id,
    required this.message,
    required this.timestamp,
    required this.seen,
    required this.ext,
    required this.extid,
    required this.actionid,
    required this.type,
    required this.postid,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      id: data['id'],
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      seen: data['seen'] ?? false,
      ext: data['ext'] ?? false,
      extid: data['extid'] ?? '',
      actionid: data['actionid'] ?? '',
      type: data['type'] ?? '',
      postid: data['postid'] ?? '',
    );
  }
}


Future<void> addNotification(String userId, String message, String title, bool ext, String extid, String actionid, String type, String postid) async {
  final uuid = Uuid();
  String id = uuid.v4();

  Map<String, dynamic> notificationData = {
    'message': message,
    'title': title,
    'timestamp': Timestamp.now(),
    'seen': false,
    'ext': ext,
    'extid': extid,
    'id': id,
    'actionid': actionid,
    'type': type,
    'postid': postid,
  };

/*
  if(userId == UserModel.currentUser().id!){
    StoredNotification().notifs.add(NotificationModel(actionid: actionid, id: id, title: title, message: message, timestamp: Timestamp.now(), seen: false, ext: ext, extid: extid, type: type));
    NotificationDatabase().insertNotification(NotificationModel(actionid: actionid,id: id, title: title, message: message, timestamp: Timestamp.now(), seen: false, ext: ext, extid: extid, type: type));
  }*/

  UserModel targetUser = UserModel();
  if(CachedData().users.containsKey(userId)){
    targetUser = CachedData().users[userId]!;
  } else {
    await targetUser.fetchExternalData(userId);
    CachedData().users[userId] = targetUser;
  }
  var userDocRef = targetUser.docRef;

  if (userDocRef != null) {
    DocumentSnapshot userSnapshot = await userDocRef.get();

    if (!userSnapshot.exists) {
      await userDocRef.set({'notifs': []}, SetOptions(merge: true));
    }

    try {
      await userDocRef.update({
        'notifs': FieldValue.arrayUnion([notificationData]),
      });
    } catch (e) {
      print('Erreur lors de la mise à jour des notifications: $e');
    }
  }

    UserModel.currentUser().notifs.add(notificationData);
}

Future<void> sendPushNotification(String id, String message, String title, String token, bool ext, String extid, String actionid, String type, String postid) async {
  try {

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendPushNotification');
    final results = await callable.call(<String, dynamic>{
      'userId': id,
      'message': message,
      'title': title,
      'fcmToken': token,
      'type': type,
      'followers': UserModel.currentUser().ftoken
    });

    if(type != "post"){
      await addNotification(id, message, title, ext, extid, actionid, type, postid);
    }


    print('Notification envoyée : ${results.data}');
  } catch (e) {
    print('Erreur lors de l\'envoi de la notification : $e');
  }
}

class NotificationDatabase {
  static final NotificationDatabase _instance = NotificationDatabase._internal();
  static Database? _database;
  static final String _userId = FirebaseAuth.instance.currentUser!.uid;

  NotificationDatabase._internal();

  factory NotificationDatabase() {
    return _instance;
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('notifications');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    if (_userId == null) {
      throw Exception("User ID must be set before accessing the database.");
    }
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'notifications_$_userId.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notifications(
            id TEXT PRIMARY KEY,
            title TEXT,
            message TEXT,
            timestamp TEXT,
            seen INTEGER,
            ext INTEGER,
            extid TEXT,
            actionid TEXT,
            type TEXT,
            postid TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertNotification(NotificationModel notification) async {
    final db = await database;
    await db.insert(
      'notifications',
      {
        'id': notification.id,
        'title': notification.title,
        'message': notification.message,
        'timestamp': notification.timestamp.toDate().toIso8601String(),
        'seen': notification.seen ? 1 : 0,
        'ext': notification.ext ? 1 : 0,
        'extid': notification.extid,
        'actionid': notification.actionid,
        'type': notification.type,
        'postid': notification.postid,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    final db = await database;
    await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  Future<List<NotificationModel>> getAll() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return NotificationModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        message: maps[i]['message'],
        timestamp: Timestamp.fromMillisecondsSinceEpoch(
            DateTime.parse(maps[i]['timestamp']).millisecondsSinceEpoch),
        seen: maps[i]['seen'] == 1,
        ext: maps[i]['ext'] == 1,
        extid: maps[i]['extid'],
        actionid: maps[i]['actionid'],
        type: maps[i]['type'],
        postid: maps[i]['postid'],
      );
    });
  }
}
