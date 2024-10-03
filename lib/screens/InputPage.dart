import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jymu/screens/Connexion/PfPage.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class InputPage extends StatefulWidget {
  final String text;
  final int limit;

  const InputPage({super.key, required this.text, required this.limit});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.redAccent,
              Colors.deepOrange,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height / 3.8,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F5F8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38.0),
                  topRight: Radius.circular(38.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.8,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child:Text(
                                    widget.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 28),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                      SizedBox(
                        height: 60,
                        child: Stack(
                          children: [
                            CupertinoTextField(
                              controller: _usernameController,
                              focusNode: _focusNode, // Ajoutez ceci
                              padding: EdgeInsets.all(15),
                              cursorColor: Colors.redAccent,
                              maxLength: widget.limit,
                              placeholder: "Ecrire ici",
                              onSubmitted: (String s){String result = _usernameController.text.trim();
                              Navigator.pop(context, result);},
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey5,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}