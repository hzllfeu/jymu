import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingPost extends StatelessWidget {
  const LoadingPost({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
      padding: EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 10),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeShimmer(
            height: 60,
            width: 60,
            radius: 40,
            highlightColor: Colors.black.withOpacity(0.15),
            baseColor: Colors.black.withOpacity(0.05),
          ),
          const SizedBox(height: 15.0),
           FadeShimmer(
            height: 25,
            width: 300,
            radius: 12,
            highlightColor: Colors.black.withOpacity(0.05),
            baseColor: Colors.black.withOpacity(0.15),
          ),
          const SizedBox(height: 20,),
          FadeShimmer(
            height: 15,
            width: 60,
            radius: 18,
            highlightColor: Colors.black.withOpacity(0.05),
            millisecondsDelay: 5,
            baseColor: Colors.black.withOpacity(0.15),
          )
        ],
      ),
    );
  }
}
