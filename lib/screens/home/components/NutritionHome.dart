import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class NutritionHome extends StatelessWidget {
  NutritionHome({
    super.key,
  });

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
        enableHapticFeedback: true,
        actions: const [
        CupertinoContextMenuAction(child: Text("Nouvel entrainement"), trailingIcon: CupertinoIcons.refresh_bold,)
        ],
      child: Container(
          width: 600,
          margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          height: 430,
          decoration: BoxDecoration(
            color: Color(0xFFEAEAEB),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.greenAccent, Colors.lightGreen.withOpacity(0.2)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    width: 50,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrangeAccent.withOpacity(0.3),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/emoji_fire.png", height: 32,),
                        const SizedBox(height: 5,),
                        Container(
                          width: 35,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.redAccent.withOpacity(0.7)
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
            Container(
              width: 600,
              height: 130,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.redAccent.withOpacity(0.6),
                    Color(0xfff57d52).withOpacity(0.8)
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(color: Color(0xffe1e1e1), fontWeight: FontWeight.w700, fontSize: 14),
                        child: Text("4 séances",),
                      ),
                      Row(
                        children: [
                          DefaultTextStyle(
                            style: TextStyle(color: Color(0xfff5f5f5), fontWeight: FontWeight.w800, fontSize: 18),
                            child: Text("Planning",),
                          ),
                          const SizedBox(width: 8,),
                          Image.asset("assets/images/emoji_calendar.png", height: 24,),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
