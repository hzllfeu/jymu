import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/PostManager.dart';

class NewPostWidget extends StatefulWidget {
  @override
  _NewPostWidgetState createState() => _NewPostWidgetState();
}

class _NewPostWidgetState extends State<NewPostWidget> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FocusNode _focusNode = FocusNode();
  bool private = false;

  Future<void> _addPost() async {
    final String content = _controller.text.trim();
    if (content.isEmpty) return;

    try {
      addPost(FirebaseAuth.instance.currentUser, content);

      _controller.clear();
      Haptics.vibrate(HapticsType.success);
    } catch (e) {
      print('Erreur lors de l\'ajout du post : $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(_updateCharacterCount);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_updateCharacterCount);

    _controller.dispose();
    _focusNode.dispose();
  }

  void _updateCharacterCount() {
    // Appeler setState pour mettre à jour l'interface utilisateur lorsque le texte change
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.redAccent,
              Colors.deepOrange,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F5F8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38.0),
                  topRight: Radius.circular(38.0),
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 1.5,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Rédige un post",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 5 * MediaQuery.of(context).size.width * 0.015,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Image.asset("assets/images/emoji_pencil.png", height: 26,)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                      SizedBox(
                        height: 100,
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: 5,
                          cursorColor: Colors.redAccent,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 18, left: 15, right: 15),
                            filled: true,
                            hintText: "Ecrire ici",
                            hintStyle: TextStyle(color: CupertinoColors.systemGrey),
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (String s) {
                            _addPost();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if(!private)
                            GestureDetector(
                              onTapUp: (t){
                                setState(() {
                                  private = true;
                                  Haptics.vibrate(HapticsType.light);
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Container(
                                  width: 145,
                                  height: 25,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
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
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        child: Text("Mettre en privé",),
                                      ),
                                      SizedBox(width: 5,),
                                      Image.asset("assets/images/emoji_locked.png", height: 15,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if(private)
                            GestureDetector(
                              onTapUp: (t){
                                setState(() {
                                  private = false;
                                  Haptics.vibrate(HapticsType.light);
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Container(
                                  width: 155,
                                  height: 25,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
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
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        child: Text("Mettre en public",),
                                      ),
                                      SizedBox(width: 5,),
                                      Image.asset("assets/images/emoji_unlocked.png", height: 15,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Text(
                            "${_controller.text.trim().length}/300  ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 5 * MediaQuery.of(context).size.width * 0.0065,
                              color: _controller.text.trim().length > 300 ? Colors.red : CupertinoColors.systemGrey,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.095),
                      GestureDetector(
                        onTapUp: (t) {
                          if(_controller.text.trim().length <= 300) {
                            _addPost();
                            Navigator.pop(context);
                          } else {
                            Haptics.vibrate(HapticsType.error);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.07,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.redAccent,
                                Colors.deepOrange,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(CupertinoIcons.arrow_right, size: 22, color: Colors.transparent,),
                              Text(
                                "Envoyer",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Icon(CupertinoIcons.arrow_right, size: 22, color: Colors.white,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
