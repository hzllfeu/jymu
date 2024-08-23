import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jymu/PostManager.dart';

class NewPostWidget extends StatefulWidget {
  @override
  _NewPostWidgetState createState() => _NewPostWidgetState();
}

class _NewPostWidgetState extends State<NewPostWidget> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addPost() async {
    final String content = _controller.text.trim();
    if (content.isEmpty) return; // Ne rien faire si le champ est vide

    try {
      addPost(FirebaseAuth.instance.currentUser, content);

      _controller.clear(); // Efface le champ de texte après l'ajout
    } catch (e) {
      print('Erreur lors de l\'ajout du post : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: _controller,
              placeholder: 'Écrivez un nouveau post...',
              maxLines: null,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(width: 10),
          CupertinoButton(
            color: CupertinoColors.activeBlue,
            child: Text('Publier'),
            onPressed: _addPost,
          ),
        ],
      ),
    );
  }
}
