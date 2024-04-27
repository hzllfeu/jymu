import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class RechercheComp extends StatefulWidget {
  const RechercheComp({super.key});

  static String routeName = "/";

  @override
  State<RechercheComp> createState() => _RechercheCompState();
}

class _RechercheCompState extends State<RechercheComp> {

  bool i = true;
  String nom = "Hugo Vincent";

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          const SizedBox(height: 20,),
          CupertinoSearchTextField(
            placeholder: "Chercher un exercice",
          )
        ],
      ),
    );
  }
}
