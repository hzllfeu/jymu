import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class HistoryComp extends StatefulWidget {
  const HistoryComp({super.key});

  static String routeName = "/";

  @override
  State<HistoryComp> createState() => _HistoryCompState();
}

class _HistoryCompState extends State<HistoryComp> {

  bool i = true;
  String nom = "Hugo Vincent";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15,),
          Container(
            width: 70,
            height: 8,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20)
            ),
          ),
          const SizedBox(height: 40,),
              const DefaultTextStyle(
                style: TextStyle(color: Color(0xffF14BA9), fontWeight: FontWeight.w700, fontSize: 26),
                child: Text("Historique",),
              ),
          const SizedBox(height: 20,),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.3)
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/emoji_calendar.png", height: 150,),
                  const SizedBox(height: 10,),
                  const DefaultTextStyle(
                    style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w500, fontSize: 14),
                    child: Text("C'est affreux ce que j'ai fais j'ai jamais vu ca",),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
