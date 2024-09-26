import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../InputPage.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class MdpComp extends StatefulWidget {
  const MdpComp({super.key});

  static String routeName = "/";

  @override
  State<MdpComp> createState() => _MdpCompState();
}

class _MdpCompState extends State<MdpComp> {
  final TextEditingController _usernameController = TextEditingController();
  bool done = false;

  bool i = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            Container(
              width: 50,
              height: 6,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
            const SizedBox(height: 30,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mot de passe oublié ?",
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 28),
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              "Entre l'email liée a ton compte pour recevoir un lien de récupération",
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black.withOpacity(0.6)),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              height: 60,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InputPage(text: "Entrer un email", limit: 50,),
                        ),
                      );

                      if (result != null) {
                        _usernameController.text = result;
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _usernameController.text.trim().isEmpty ? "Entrer un email" : _usernameController.text.trim(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTapUp: (t) async {
                    if(!done){
                      String email = _usernameController.text.trim();
                      if(!email.isEmpty){
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                        setState(() {
                          done = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 70,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.redAccent,
                          Colors.deepOrange,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffF14BA9).withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(!done)
                          Text(
                            "Envoyer",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                          ),
                        if(!done)
                          SizedBox(width: 15,),
                        Icon(done ? CupertinoIcons.check_mark : CupertinoIcons.arrow_right, color: Colors.white, size: 20,)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
