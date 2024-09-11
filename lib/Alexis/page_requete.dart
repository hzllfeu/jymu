import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jymu/screens/home/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:jymu/Alexis/page_terminer.dart';
import 'package:jymu/Alexis/ia_init_var_user.dart';


String generateFirebaseLikeId({int length = 20}) {
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final Random random = Random.secure();
  return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join('');

}

Future<void> FetchProfile(BuildContext context) async {
  // Generate a new UUID
  var uuid = Uuid();
  String newUuid = uuid.v4();
  // Accéder à la liste dynamique partagée
  List<double> tab = GlobalListManager().dynamicList;


  CollectionReference requests = FirebaseFirestore.instance.collection('requests');
  await requests.doc(newUuid).set({
    'tab': tab,
  });


  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LoadingPage(uuid: newUuid),
    ),
  );

  _monitorFirestore(context, newUuid);
}

void _monitorFirestore(BuildContext context, String uuid) {
  FirebaseFirestore.instance
      .collection('processed')
      .doc(uuid)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.exists) {
      // Extraire uniquement la valeur de "result" dans un tableau
      List<dynamic>? result = snapshot.data()?["result"] as List<dynamic>?;

      // Naviguer vers HomeScreen en passant uniquement "result"
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EndPage(),
        ),
      );
    }
  });
}



class LoadingPage extends StatelessWidget {
  final String uuid;

  LoadingPage({required this.uuid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoActivityIndicator(radius: 17),
                SizedBox(height: 20),
                Container(
                  width: 250,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Notre IA est en plein leg-day,', style: TextStyle(color: Colors.grey.withOpacity(0.9), fontWeight: FontWeight.w600, fontSize: 16),),
                      Text('elle peut être un peu lente', style: TextStyle(color: Colors.grey.withOpacity(0.9), fontWeight: FontWeight.w600, fontSize: 16),),
                    ],
                  ),
                ),
                SizedBox(height: 280),
                Text('Si la requéte prend plus de 1 minutes', style: TextStyle(color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w600),),
                Text('contacte le support', style: TextStyle(color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w600),),
                SizedBox(height: 20),
                Text('$uuid', style: TextStyle(color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w500),),
                SizedBox(height: 30),
              ],
            ),
          ),
        )
    );
  }
}