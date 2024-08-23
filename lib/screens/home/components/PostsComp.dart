import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class PostComp extends StatefulWidget {
  const PostComp({super.key});

  static String routeName = "/";

  @override
  State<PostComp> createState() => _PostCompState();
}

class _PostCompState extends State<PostComp> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100,),
            Icon(CupertinoIcons.nosign, color: CupertinoColors.systemGrey, size: 46,),
            const SizedBox(height: 10,),
            Text("Il n'y a pas encore de posts", style: TextStyle(color: CupertinoColors.systemGrey, fontWeight: FontWeight.w600, fontSize: 18),)
          ],
        ),
      )
    );
  }
}
