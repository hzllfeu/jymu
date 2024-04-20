import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: SearchField()),
          SizedBox(width: 16),
          SizedBox(width: 8),
          Icon(CupertinoIcons.bell_fill, color: Colors.grey,)
        ],
      ),
    );
  }
}
