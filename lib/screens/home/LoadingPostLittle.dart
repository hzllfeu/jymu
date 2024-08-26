import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingPostLittle extends StatelessWidget {
  const LoadingPostLittle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 10),
      width: 122,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeShimmer(
            height: 30,
            width: 30,
            radius: 40,
            highlightColor: Colors.black.withOpacity(0.15),
            baseColor: Colors.black.withOpacity(0.05),
          ),
          const SizedBox(height: 10),
           FadeShimmer(
            height: 12.5,
            width: 80,
            radius: 6,
            highlightColor: Colors.black.withOpacity(0.05),
            baseColor: Colors.black.withOpacity(0.15),
          ),
        ],
      ),
    );
  }
}
