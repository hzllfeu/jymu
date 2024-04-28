import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProBanner extends StatelessWidget {
  const ProBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.amberAccent.withOpacity(0.8), Colors.deepOrangeAccent.withOpacity(0.8)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Découvre ",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 3,),
                      Container(
                        width: 120,
                        height: 35,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultTextStyle(
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black),
                              child: Text("JymuPro",),
                            ),
                            Image.asset(
                              "assets/images/emoji_goat.png",
                              height: 20,
                            ),
                          ],
                          ),
                        ),
                  ],
                ),
                const SizedBox(height: 10,),
                Text(
                  "Met à jour ton entrainement et plus!",
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Image.asset("assets/images/emoji_fire.png", height: 26,)
          ]
        )
    );
  }
}
