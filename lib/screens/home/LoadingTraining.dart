import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingTraining extends StatelessWidget {
  const LoadingTraining({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            FadeShimmer(
              height: MediaQuery.of(context).size.height*0.44,
              width: MediaQuery.of(context).size.width*0.9,
              radius: 18,
              highlightColor: Colors.black.withOpacity(0.15),
              baseColor: Colors.black.withOpacity(0.05),
            ),
            const SizedBox(height: 30),
            FadeShimmer(
              height: MediaQuery.of(context).size.height*0.05,
              width: MediaQuery.of(context).size.width*0.9,
              radius: 18,
              highlightColor: Colors.black.withOpacity(0.05),
              baseColor: Colors.black.withOpacity(0.15),
            ),
            const SizedBox(height: 15),
            FadeShimmer(
              height: MediaQuery.of(context).size.height*0.05,
              width: MediaQuery.of(context).size.width*0.9,
              radius: 18,
              highlightColor: Colors.black.withOpacity(0.05),
              baseColor: Colors.black.withOpacity(0.15),
            ),
          ],
        ),
      );
  }
}