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
        margin: const EdgeInsets.symmetric(horizontal: 5),
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
              child: const Text("Ami avec timy"),
            ),
            const SizedBox(width: 5),
            Image.asset("assets/images/emoji_hands.png", height: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if(tag == "og"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), // Adapté en fonction de la taille de l'écran
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
                fontSize: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), // Adapté
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Membre OG"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_cent.png", height: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)), // Adapté
          ],
        ),
      ),
    );
  }

  if(tag == "gymrat"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), // Adapté
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
                fontSize: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), // Adapté
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Gymrat"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_hero.png", height: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)), // Adapté
          ],
        ),
      ),
    );
  }

  if(tag == "cardio"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), // Adapté
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
                fontSize: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), // Adapté
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Cardio"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_air.png", height: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)), // Adapté
          ],
        ),
      ),
    );
  }

  if(tag == "power"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), // Adapté
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
                fontSize: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), // Adapté
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Power Lifter "),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_power.png", height: 6 * (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)), // Adapté
          ],
        ),
      ),
    );
  }

  if(tag == "body"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), // Adapté
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), // Adapté
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Bodybuilder"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_sigma.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)), // Adapté
          ],
        ),
      ),
    );
  }

  if(tag == "athletic"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), // Adapté
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), // Adapté
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Athletic"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_goat.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)), // Adapté
          ],
        ),
      ),
    );
  }

  if(tag == "gymbro"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), // Adapté
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), // Adapté
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Gymbro"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_gymbro.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)), // Adapté
          ],
        ),
      ),
    );
  }

  if(tag == "gym"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), // Adapté
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), // Adapté
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("A la Salle"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_house.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)), // Adapté
          ],
        ),
      ),
    );
  }

  if(tag == "streetworkout"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), // Adapté
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width), // Adapté
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Street Workout"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_arbre.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)), // Adapté
          ],
        ),
      ),
    );
  }
  if(tag == "gymgirl"){
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Gym girl"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_femme.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if(tag == "runner") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Course à Pieds"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_runner.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "10k pas") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("10k Pas"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_steps.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "15k pas") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("15k Pas"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_steps.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }
  if (tag == "20k pas") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("20k Pas"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_steps.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }
  if (tag == "PecsL") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Pecs"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coeur.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "JambesL") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Jambes"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coeur.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "BrasL") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Bras"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coeur.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "FessesL") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Fesses"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coeur.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "EpaulesL") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Epaules"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coeur.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "AbdosL") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Abdos"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coeur.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "DosL") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Dos"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coeur.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "TricepsL") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Triceps"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coeur.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "BicepsL") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Biceps"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coeur.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }
  if (tag == "TrapèzesL") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Trapèzes"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coeur.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "PecsD") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Pecs"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_vomi.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "JambesD") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Jambes"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_vomi.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "BrasD") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Bras"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_vomi.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "FessesD") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Fesses"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_vomi.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "EpaulesD") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Epaules"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_vomi.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "AbdosD") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Abdos"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_vomi.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "DosD") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Dos"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_vomi.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "TricepsD") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Triceps"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_vomi.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "BicepsD") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Biceps"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_vomi.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "TrapezesD") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Trapèzes"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_vomi.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "cardioL") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Cardio"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coeur.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "cardioD") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Cardio"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_vomi.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }





  if (tag == "winter arc") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Winter Arc"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_winter.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }


  if (tag == "looking for a partner") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Looking for a Partner"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_partner.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "looking for a coach") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Looking for a Coach"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coach.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "prise de masse") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Prise de Masse"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_mass.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "sèche") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Sèche"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_dry.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }




  if (tag == "fissure") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Fissure"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_fissure.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "sigma") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Sigma"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_sigma.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "SBD +200") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("SBD +200"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_sbd.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }
  if (tag == "maison") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Maison"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_maison.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "football") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Football"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_football.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "basket-ball") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Basket-Ball"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_basketball.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "tennis") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Tennis"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_tennis.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "rugby") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Rugby"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_rugby.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "natation") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Natation"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_natation.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "boxe") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Boxe"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_boxe.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "golf") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Golf"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_golf.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "athlétisme") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Athlétisme"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_athletisme.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "hockey sur glace") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Hockey sur Glace"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_hockey.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "vélo") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Vélo"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_velo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "volleyball") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Volleyball"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_volleyball.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "handball") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Handball"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_handball.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "courseapied") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Course à Pied"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_course.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "CoachF") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("A la recherche d'un coach"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_coach_femme.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "CrushF") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("A la recherche de son Gym Crush"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_crush.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Partenaire") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("A la recherche d'un Partenaire"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_partenaire.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Squat") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Squat"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Développé couché") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Développé couché"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Soulevé de terre") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Soulevé de terre"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Tractions") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Tractions"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Dips") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Dips"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Développé militaire") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Développé militaire"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Fentes") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Fentes"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Curl biceps") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Curl biceps"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Extensions triceps") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Extensions triceps"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Rowing") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Rowing"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Crunches") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Crunches"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Pompes") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Pompes"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_exo.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "collation") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Collation"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_collation.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "repas") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Repas"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_repas.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Jour de repos") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Jour de repos"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_repos.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "Jeune Intermittent") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Jeune Intermittent"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_intermittent.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "food") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Food"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_food.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "pump") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Pump"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_pump.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }

  if (tag == "posing") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Posing"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_miroir.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }


  if (tag == "nuit") {
    return IntrinsicWidth(
      child: Container(
        height: 13 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
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
                fontSize: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text("Nuit"),
            ),
            SizedBox(width: 5),
            Image.asset("assets/images/emoji_nuit.png", height: 6 * (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width)),
          ],
        ),
      ),
    );
  }













  return SizedBox();
}

List<dynamic> getTagList(){
  return ["new", "jymupro", "timy","og","muscu","cardio","power","body","athletic","gym", "Soulevé de terre", "Tractions","streetworkout","maison","gymrat","DosL","gymbro", "gymgirl","CoachF", "CrushF","Partenaire","PecsD","JambesD","BrasD", "prise de masse","sèche","runner", "10k pas", "15k pas", "20k pas", "PecsL","JambesL","food","pump","BrasL","FessesL","boxe", "hockey sur glace", "vélo", "volleyball", "handball" ,"Courseapied","SBD", "collation","repas", "Jour de repos","Jeune Intermittent","rugby", "Crunches","posing","nuit","EpaulesL","AbdosL","FessesD","EpaulesD","TricepsD", "fissure","BicepsD","cardioD","winter arc","sigma","Squat", "TrapezesL","cardioL","Développé couché", "Dips","AbdosD","DosD", "Développé militaire","TricepsL","BicepsL", "Fentes", "Curl biceps", "Extensions triceps", "Rowing", "football", "basket-ball", "tennis",  "Pompes","natation","golf", "athlétisme","TrapezesD"];
}