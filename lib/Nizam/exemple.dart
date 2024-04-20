import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//une mentalité de merde

class ExempleNizam extends StatelessWidget {
  const ExempleNizam({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
     width: double.infinity,
      height: (230),
      margin: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("training", style: TextStyle(color: Colors.white, fontSize: 30),),
                SizedBox(height: 15,),
                Text("Fitness")
              ],
            ),
            Image.asset("assets/images/emoji_sablier.png", height: 26,)
          ],
        ),
      )
    );
  }
}
