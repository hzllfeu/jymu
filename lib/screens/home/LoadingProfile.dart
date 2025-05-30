import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingProfile extends StatelessWidget {
  const LoadingProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
      padding: EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 10),
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeShimmer(
            height: 80,
            width: 80,
            radius: 50,
            highlightColor: Colors.black.withOpacity(0.15),
            baseColor: Colors.black.withOpacity(0.05),
          ),
           Column(
             children: [
               FadeShimmer(
                 height: 25,
                 width: 100,
                 radius: 6,
                 highlightColor: Colors.black.withOpacity(0.05),
                 baseColor: Colors.black.withOpacity(0.15),
               ),
               SizedBox(height: 15,),
               FadeShimmer(
                 height: 20,
                 width: 150,
                 radius: 18,
                 highlightColor: Colors.black.withOpacity(0.05),
                 millisecondsDelay: 5,
                 baseColor: Colors.black.withOpacity(0.15),
               )
             ],
           )
        ],
      ),
    );
  }
}
