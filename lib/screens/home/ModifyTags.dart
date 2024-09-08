import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:jymu/PostManager.dart';
import 'package:jymu/screens/home/components/TagList.dart';

class ModifyTags extends StatefulWidget {
  late List<dynamic> tags;

  ModifyTags({super.key, required this.tags});

  @override
  _ModifyTagsState createState() => _ModifyTagsState();
}

class _ModifyTagsState extends State<ModifyTags> {
  final TextEditingController _controller = TextEditingController();
  late List<dynamic> allTags;
  late List<dynamic> tags;

  @override
  void initState() {
    super.initState();
    tags = widget.tags;
    allTags = getTagList().where((tag) => !tags.contains(tag)).toList();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void toggleTagSelection(String tag) {
    setState(() {
      if (tags.contains(tag)) {
        tags.remove(tag); // Retire des tags sélectionnés
        allTags.add(tag); // Remet dans les tags disponibles
      } else {
        tags.add(tag); // Ajoute aux tags sélectionnés
        allTags.remove(tag); // Retire des tags disponibles
      }
      Haptics.vibrate(HapticsType.light);
    });
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
        child: Stack(
          children: [

            Positioned(
              top: 70,
              right: 15,
              child: GestureDetector(
                    onTapUp: (t)  {
                      Navigator.pop(context, tags);
                    },
                    child: GlassContainer(
                      height: 38,
                      width: 140,
                      color: Colors.white.withOpacity(0.8),
                      blur: 10,
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text(
                              "Enregistrer",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 7*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), color: Colors.black.withOpacity(0.7)),
                            ),
                        ],
                      ),
                    ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      runSpacing: 8.0,
                      children: tags.map((tag) {
                        return GestureDetector(
                            onTap: () => toggleTagSelection(tag),
                            child: getTag(tag.toString(), true)
                        );
                      }).toList(),
                    ),
                  ),

                SizedBox(height: 45*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),),

                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F5F8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(38.0),
                      topRight: Radius.circular(38.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CupertinoSearchTextField(
                            controller: _controller,
                            placeholder: "Rechercher un tag",
                            onChanged: (value) {
                              setState(() {
                                allTags = getTagList().where((tag) => tag.contains(value) && !tags.contains(tag)).toList();
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        // Affichage des tags disponibles

                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              runSpacing: 8.0,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              children: allTags.map((tag) {
                                return GestureDetector(
                                    onTap: () => toggleTagSelection(tag), // Gère la sélection/désélection
                                    child: getTag(tag.toString(), true)
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
