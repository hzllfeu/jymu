import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainingComp extends StatelessWidget {
  TrainingComp({
    super.key,
  });

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      height: 330,
      decoration: BoxDecoration(
        color: Color(0xFFEAEAEB),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFEAEAEB), Color(0xffEFB5A2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Couleur de l'ombre
            spreadRadius: 5, // Rayon de diffusion
            blurRadius: 7, // Flou de l'ombre
            offset: Offset(0, 3), // Décalage de l'ombre
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 90,
                width: 180,
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xffff7f51), Colors.red],
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Haut du corps",
                          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 16),
                        ),
                        Image.asset("assets/images/emoji_muscle.png", height: 26,)
                      ],
                    ),
                        Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: DashedCircularProgressBar.aspectRatio(
                                aspectRatio: 1, // width ÷ height
                                valueNotifier: _valueNotifier,
                                progress: 55,
                                startAngle: 225,
                                sweepAngle: 270,
                                foregroundColor: Colors.orangeAccent,
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
                            ),
                            const SizedBox(width: 10,),
                            const Text(
                              "13 Exercices",
                              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
              Container(
                height: 90,
                width: 180,
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xffa7c957), Color(0xff6a994e)],
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Bas du corps",
                          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 16),
                        ),
                        Image.asset("assets/images/emoji_leg.png", height: 26,)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: DashedCircularProgressBar.aspectRatio(
                            aspectRatio: 1, // width ÷ height
                            valueNotifier: _valueNotifier,
                            progress: 37,
                            startAngle: 225,
                            sweepAngle: 270,
                            foregroundColor: Colors.lightBlueAccent,
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
                        ),
                        const SizedBox(width: 10,),
                        const Text(
                          "7 Exercices",
                          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 90,
                width: 180,
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xff00f5d4), Color(0xff00bbf9)],
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Cardio ",
                          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 16),
                        ),
                        Image.asset("assets/images/emoji_running.png", height: 26,)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: DashedCircularProgressBar.aspectRatio(
                            aspectRatio: 1, // width ÷ height
                            valueNotifier: _valueNotifier,
                            progress: 70,
                            startAngle: 225,
                            sweepAngle: 270,
                            foregroundColor: Colors.lightGreen,
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
                        ),
                        const SizedBox(width: 10,),
                        const Text(
                          "3 Exercices",
                          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 133,
                width: 160,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xffff7f51), Color(0xffce4257)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                      spreadRadius: 5, // Rayon de diffusion
                      blurRadius: 7, // Flou de l'ombre
                      offset: Offset(0, 3), // Décalage de l'ombre
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Planning",
                          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 17),
                        ),
                        Image.asset("assets/images/emoji_calendar.png", height: 26,)
                      ],
                    ),
                    const SizedBox(height: 15,),
                    const Text(
                      "4 séances / semaine",
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 5,),
                    const Text(
                      "70 minutes / séance",
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 5,),
                    const Text(
                      "Split push-pull-leg",
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}
