import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExoTemplate extends StatelessWidget {
  ExoTemplate({
    super.key,
  });
  String nom = "Tirage vertical à la poulie";
  String type = "Uni articulaire";
  String muscle = "Triceps (longue portion)";
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 155,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.orange
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nom,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFFEAEAEB),
                      ),
                      child: Center(
                        child: Icon(CupertinoIcons.photo_camera_solid,color: Colors.grey,),
                      ),
                    ),
                    const SizedBox(width: 15,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          muscle,
                          style: const TextStyle(color: Colors.white, fontSize: 16,),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          type,
                          style: const TextStyle(color: Colors.white, fontSize: 16,),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/emoji_muscle.png", height: 30,),
                const SizedBox(height: 40,),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: DashedCircularProgressBar.aspectRatio(
                    aspectRatio: 1, // width ÷ height
                    valueNotifier: _valueNotifier,
                    progress: 37,
                    startAngle: 225,
                    sweepAngle: 270,
                    foregroundColor: Colors.redAccent,
                    backgroundColor: const Color(0xffeeeeee),
                    foregroundStrokeWidth: 7,
                    backgroundStrokeWidth: 7,
                    animation: true,
                    seekSize: 0,
                    child: Center(
                      child: ValueListenableBuilder(
                          valueListenable: _valueNotifier,
                          builder: (_, double value, __) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            ],
                          )
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        )
    );

  }
}
