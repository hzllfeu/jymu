import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class TrainingComp extends StatelessWidget {
  TrainingComp({
    super.key,
  });

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          height: 430,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              ],
            ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 30),
              ClipPath(
                clipper: MyCustomClipper(),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 150,
                        height: 210,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffFEB99F).withOpacity(0.7),
                              spreadRadius: 40,
                              blurRadius: 20,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 210,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xffFA8A8D), Color(0xffFEB99F)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffFEB99F).withOpacity(0.7),
                            spreadRadius: 8,
                            blurRadius: 20,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 80,),
                          Text("Musculation", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),),
                          SizedBox(height: 10,),
                          Text("Pecs, épaules", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("11", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 26),),
                              SizedBox(width: 5,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 5,),
                                  Text("exos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
                                ],
                              )

                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: -75,
                      left: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: const BoxDecoration(
                          color: Color(0xffffaeb7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 15,
                      child: Image.asset("assets/images/image_poids.png", height: 90,),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              ClipPath(
                clipper: MyCustomClipper(),
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 210,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xff7589DE), Color(0xff777cec)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff676CE3).withOpacity(0.7),
                            spreadRadius: 4,
                            blurRadius: 20,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -75,  // Ajuster la position verticale
                      left: -30,  // Ajuster la position horizontale
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Color(0xff94AAEA),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 25,
                      child: Image.asset("assets/images/image_coeur.png", height: 70,),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              ClipPath(
                clipper: MyCustomClipper(),
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 210,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xffFE99BA), Color(0xffFF5F94)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffFE99BA).withOpacity(1),
                            spreadRadius: 4,
                            blurRadius: 20,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),

                    ),
                    Positioned(
                      top: -75,
                      left: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: const BoxDecoration(
                          color: Color(0xffFFBFD2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 20,
                      child: Image.asset("assets/images/image_mobilite.png", height: 80,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
          ],
        ),
    );

  }


}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = 16.0;
    final bigRadius = 80.0;

    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - bigRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, bigRadius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}