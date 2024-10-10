import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'CachedData.dart';

class StoredNotification {

  static final StoredNotification _instance = StoredNotification._internal();

  int n = 0;
  List<NotificationModel> notifs = [];

  Future<void> getNotifications(String userId) async {

    if (UserModel.currentUser() != null){
      notifs = UserModel.currentUser().notifs!
          .map((notif) => NotificationModel.fromMap(notif))
          .toList();

      List<NotificationModel> flist = await NotificationDatabase().getAll();
      n = notifs.length;

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
    );
  }
}


Future<void> addNotification(String userId, String message, String title, bool ext, String extid, String actionid, String type) async {
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
    'type': type
  };

  if(userId == UserModel.currentUser().id!){
    StoredNotification().notifs.add(NotificationModel(actionid: actionid, id: id, title: title, message: message, timestamp: Timestamp.now(), seen: false, ext: ext, extid: extid, type: type));
    NotificationDatabase().insertNotification(NotificationModel(actionid: actionid,id: id, title: title, message: message, timestamp: Timestamp.now(), seen: false, ext: ext, extid: extid, type: type));
  }

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
      // Initialise 'notifs' si elle n'existe pas
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

    UserModel.currentUser().notifs?.add(notificationData);
}

Future<void> sendPushNotification(String id, String message, String title, String token, bool ext, String extid, String actionid, String type) async {
  try {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendPushNotification');
    final results = await callable.call(<String, dynamic>{
      'userId': id,
      'message': message,
      'title': title,
      'fcmToken': token,
    });

    await addNotification(id, message, title, ext, extid, actionid, type);

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
            type TEXT
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
        'type': notification.type
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
        type: maps[i]['type']
      );
    });
  }
}

class NotificationController {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
              (silentData) => onActionReceivedImplementationMethod(silentData));

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      print(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    } else {
      // this process is only necessary when you need to redirect the user
      // to a new page or use a valid context, since parallel isolates do not
      // have valid context, so you need redirect the execution to main isolate
      if (receivePort == null) {
        print(
            'onActionReceivedMethod was called inside a parallel dart isolate.');
        SendPort? sendPort =
        IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          print('Redirecting the execution to main isolate process.');
          sendPort.send(receivedAction);
          return;
        }
      }

      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification-page',
            (route) =>
        (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }

  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    print(re.body);
    print("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification(String title, String body) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: 'alerts',
            title: title,
            body:
            body,
            notificationLayout: NotificationLayout.Default,
        ));
  }

  static Future<void> scheduleNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await myNotifyScheduleInHours(
        title: 'test',
        msg: 'test message',
        heroThumbUrl:
        'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
        hoursFromNow: 5,
        username: 'test user',
        repeatNotif: false);
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}

Future<void> myNotifyScheduleInHours({
  required int hoursFromNow,
  required String heroThumbUrl,
  required String username,
  required String title,
  required String msg,
  bool repeatNotif = false,
}) async {
  var nowDate = DateTime.now().add(Duration(hours: hoursFromNow, seconds: 5));
  await AwesomeNotifications().createNotification(
    schedule: NotificationCalendar(
      //weekday: nowDate.day,
      hour: nowDate.hour,
      minute: 0,
      second: nowDate.second,
      repeats: repeatNotif,
      //allowWhileIdle: true,
    ),
    // schedule: NotificationCalendar.fromDate(
    //    date: DateTime.now().add(const Duration(seconds: 10))),
    content: NotificationContent(
      id: -1,
      channelKey: 'basic_channel',
      title: '${Emojis.food_bowl_with_spoon} $title',
      body: '$username, $msg',
      bigPicture: heroThumbUrl,
      notificationLayout: NotificationLayout.BigPicture,
      //actionType : ActionType.DismissAction,
      color: Colors.black,
      backgroundColor: Colors.black,
      // customSound: 'resource://raw/notif',
      payload: {'actPag': 'myAct', 'actType': 'food', 'username': username},
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'NOW',
        label: 'btnAct1',
      ),
      NotificationActionButton(
        key: 'LATER',
        label: 'btnAct2',
      ),
    ],
  );
}
