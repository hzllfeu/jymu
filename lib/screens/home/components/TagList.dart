import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getTag(String tag, bool list, context){
  if(tag == "showmore"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
        padding: EdgeInsets.symmetric(horizontal: list ? 10 : 5),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Voir plus "),
            ),
            SizedBox(width: 5),
            Icon(CupertinoIcons.plus_circled, color: Colors.black.withOpacity(0.7), size: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),)
          ],
        ),
      ),
    );
  }
  if(tag == "muscu"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
        padding: EdgeInsets.symmetric(horizontal: list ? 10 : 5),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Musculation "),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_muscle.png", height: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if(tag == "new"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
        padding: EdgeInsets.symmetric(horizontal: list ? 10 : 5),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Nouveau "),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_sablier.png", height: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if(tag == "jymupro"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
        padding: EdgeInsets.symmetric(horizontal: list ? 10 : 5),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Jymu Pro "),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_fire.png", height: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if(tag == "timy"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
        padding: EdgeInsets.symmetric(horizontal: list ? 10 : 5),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Ami avec timy "),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_hands.png", height: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  return SizedBox();
}

List<dynamic> getTagList(){
  return ["muscu", "new", "jymupro", "timy"];
}