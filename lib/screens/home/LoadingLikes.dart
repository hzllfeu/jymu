import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jymu/screens/home/LoadingPost.dart';

import 'LoadingPostLittle.dart';

class LoadingLikes extends StatelessWidget {
  const LoadingLikes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: ListView(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  LoadingPostLittle(),
                  const SizedBox(height: 8),
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                  LoadingPostLittle(),
                  const SizedBox(height: 8),
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              Column(
                children: [
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                  LoadingPostLittle(),
                  const SizedBox(height: 8),
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                  LoadingPostLittle(),
                  const SizedBox(height: 8),
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              Column(
                children: [
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                  LoadingPostLittle(),
                  const SizedBox(height: 8),
                  FadeShimmer(
                    height: 150,
                    width: 122,
                    radius: 8,
                    highlightColor: Colors.black.withOpacity(0.05),
                    baseColor: Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 8),
                  LoadingPostLittle(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
