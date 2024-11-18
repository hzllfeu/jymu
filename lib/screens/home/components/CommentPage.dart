import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/screens/home/CommentListComp.dart';
import 'package:jymu/screens/home/components/Notification.dart';

import '../../../Models/TrainingModel.dart';
import '../../InputPage.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class CommentPage extends StatefulWidget {
  final TrainingModel trn;

  const CommentPage({super.key, required this.trn});

  static String routeName = "/";

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {

  bool i = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10,),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w700, fontSize: 20),
                    child: const Text("Commentaires"),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.black.withOpacity(0.05),
              ),
              if (widget.trn.comments!.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.trn.comments!.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 25), // espace entre les éléments
                    itemBuilder: (context, index) {
                      Map<String, dynamic> comment = widget.trn.comments![index];
                      final commentId = comment.keys.first;
                      final commentDetails = comment.values.first;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CommentListComp(id: commentId, comment: commentDetails),
                      );
                    },
                  ),
                )
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
                      child: Image.asset("assets/images/emoji_com.png", height: 28,),
                    ),
                    SizedBox(height: 15,),
                    DefaultTextStyle(
                      style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 15),
                      child: Text("Oula c'est vide ici !"),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTapUp: (t) async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputPage(text: "Ton commentaire", limit: 300),
                  ),
                );
                if(result != null){
                  await widget.trn.addComment(result.toString());
                  Haptics.vibrate(HapticsType.success);
                  setState(() {

                  });
                }
              },
              child: GlassContainer(
                height: MediaQuery.of(context).size.height*0.1,
                color: Colors.redAccent.withOpacity(0.8),
                blur: 10,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30)
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(color: Colors.white.withOpacity(1), fontWeight: FontWeight.w700, fontSize: 18),
                        child: Text("Commenter"),
                      ),
                      SizedBox(width: 10,),
                      Image.asset("assets/images/emoji_com.png", height: 20,),
                    ],
                  ),
                )
              ),
            )
          ),
        ],
      ),
    );
  }
}
