import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingProfileList extends StatelessWidget {
  const LoadingProfileList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      child:  Row(
        children: [
          FadeShimmer(
            height: 50,
            width: 50,
            radius: 40,
            highlightColor: Colors.black.withOpacity(0.15),
            baseColor: Colors.black.withOpacity(0.05),
          ),
          const SizedBox(width: 15),
           Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               FadeShimmer(
                 height: 20,
                 width: 100,
                 radius: 5,
                 highlightColor: Colors.black.withOpacity(0.05),
                 baseColor: Colors.black.withOpacity(0.15),
               ),
               const SizedBox(height: 7),
               FadeShimmer(
                 height: 15,
                 width: 80,
                 radius: 5,
                 highlightColor: Colors.black.withOpacity(0.05),
                 baseColor: Colors.black.withOpacity(0.15),
               ),
             ],
           )
        ],
      ),
    );
  }
}
