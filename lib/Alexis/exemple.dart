import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//une mentalité de merde

class Exemple extends StatelessWidget {
  const Exemple({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration (
        color: Colors.brown,
        borderRadius: BorderRadius.circular(15),

      ) ,
      height : 150,
      width : double.infinity,
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text("Entrainement", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87), textAlign: TextAlign.start, ),
              SizedBox(height: 30),
              Image.asset("assets/images/emoji_sablier.png", height: 26,)
            ],
          ),

          Text("Entrainement", style: TextStyle(fontWeight: FontWeight.w100, fontSize: 10, color: Colors.black87), textAlign: TextAlign.start, ),


        ],
    ),
    );

  }
}
