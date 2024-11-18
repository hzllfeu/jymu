import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jymu/Models/UserModel.dart';
import 'package:jymu/UserManager.dart';
import 'package:jymu/screens/home/ModifyTags.dart';

import '../../InputPage.dart';
import '../../init_screen.dart';
import 'TagList.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class ModifyAccount extends StatefulWidget {
  final String? pp;

  const ModifyAccount({super.key, required this.pp});

  static String routeName = "/";

  @override
  State<ModifyAccount> createState() => _ModifyAccountState();
}

class _ModifyAccountState extends State<ModifyAccount> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  late Map<String, dynamic> data;
  bool done = false;
  late String id;
  late String displayname = "";
  late String bio = "";
  late List<dynamic> tags;

  File? _image;
  bool ImageChanged = false;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        ImageChanged = true;
      });
    }
  }



  @override
  void initState() {
    super.initState();
    id = UserModel.currentUser().id!;
    displayname = UserModel.currentUser().displayName!;
    bio = UserModel.currentUser().bio!;
    tags = UserModel.currentUser().tags!;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/3,
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
                ),
              ),

              Positioned(
                top: 70,
                left: 15,
                child: GestureDetector(
                  onTapUp: (t) {
                    Navigator.pop(context);
                  },
                  child: GlassContainer(
                    height: 38,
                    width: 43,
                    blur: 8,
                    shadowStrength: 5,
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.arrow_left,
                        size: 22,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 70,
                right: 15,
                child: GestureDetector(
                  onTapUp: (t) {
                    Navigator.pop(context);
                  },
                  child: GestureDetector(
                    onTapUp: (t) async {
                      if(!done){
                        setState(() {
                          done = true;
                        });

                        String display = nameController.text.trim();
                        String tmpbio = bioController.text.trim();
                        //TODO verifier si bio et dsp name sont correct (taille etc)
                        if(!display.isEmpty){
                          await setDisplayName(id, display);
                        }
                        if(!tmpbio.isEmpty){
                          await setBio(id, tmpbio);
                        }

                        await setTagFromUser(id, tags);

                        if(ImageChanged){
                          final ref = FirebaseStorage.instance
                              .ref()
                              .child('user_profiles')
                              .child('$id.jpg');

                          await ref.putFile(_image!);
                        }
                        Haptics.vibrate(HapticsType.success);
                        Navigator.pop(context);
                        await Future.delayed(const Duration(milliseconds: 300));
                        InterMessageManager().showmessage(text: "Enregistré", context: context);
                      }
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
                          if(!done)
                            Text(
                              "Enregistrer",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 7*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width), color: Colors.black.withOpacity(0.7)),
                            ),
                          if(done)
                            CupertinoActivityIndicator(color: Colors.black.withOpacity(0.7), radius: 4*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),)
                        ],
                      ),
                    ),
                  )
                ),
              ),


          Positioned(
            top: MediaQuery.of(context).size.height * 0.3 - 50,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.7 + 50,
              width: double.infinity,
              decoration: const BoxDecoration(
              color: Color(0xFFF3F5F8),
              borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28.0),
              topRight: Radius.circular(28.0),
              ),
            ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text(
                              "Modifie ton profil  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 28),
                            ),
                            Image.asset("assets/images/emoji_pencil.png", height: 24,)
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Text(
                          "Tu peux modifier ton nom tous les 14 jours. Des informations inapropriées seront sanctionnées",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black.withOpacity(0.6)),
                        ),
                        const SizedBox(height: 30,),
                        Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: ImageChanged
                                    ? Image.file(
                                  _image!,
                                  fit: BoxFit.cover,

                                )
                                    : CachedNetworkImage(
                                  imageUrl: widget.pp ?? 'https://via.placeholder.com/150',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => FadeShimmer(
                                    width: 60,
                                    height: 60,
                                    highlightColor: Colors.grey.shade200,
                                    baseColor: Colors.grey.shade300,
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            GestureDetector(
                              onTap: _pickImage,
                              child: const Text(
                                "Changer ta photo de profil",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16, color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15,),
                        Container(color: CupertinoColors.systemGrey4, width: double.infinity, height: 1.5,),
                        const SizedBox(height: 25,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            GestureDetector(
                              onTapUp: (t) async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModifyTags(tags: tags),
                                  ),
                                );
                                if (result != null) {
                                  tags = result;
                                  setState(() {});
                                }
                              },
                              child: const Text(
                                "Tags",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),

                            // Flexible widget to avoid overflow
                            Flexible(
                              child: SizedBox(
                                height: 50,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.black.withOpacity(0.00),  // Moins opaque au début (plus court à gauche)
                                          Colors.black.withOpacity(0.0),
                                          Colors.black.withOpacity(0.5),
                                          Colors.black.withOpacity(0.7),
                                          Colors.black.withOpacity(0.9),
                                          Colors.black,  // Opacité totale à droite
                                          Colors.transparent,  // Transparence totale à droite
                                        ],
                                        stops: [0.0, 0.005, 0.03, 0.2, 0.5, 0.85, 1.0],
                                      ).createShader(bounds);
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: List.generate(
                                            tags?.length ?? 0,
                                                (index) => getTag(tags![index] ?? "false", false, context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15,),
                        Container(color: CupertinoColors.systemGrey4, width: double.infinity, height: 1.5,),
                        const SizedBox(height: 25,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            Text(
                              "Nom",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18, color: Colors.redAccent),
                            ),
                            SizedBox(width: 40),
                            Expanded(  // Utilisation de Expanded ici
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InputPage(text: "Modifiez votre nom", limit: 30),
                                    ),
                                  );

                                  if (result != null) {
                                    nameController.text = result;
                                    displayname = result;
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey5,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    displayname,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25,),
                        Container(color: CupertinoColors.systemGrey4, width: double.infinity, height: 1.5,),
                        const SizedBox(height: 15,),

                        Row(
                          children: [
                            SizedBox(width: 10),
                            Text(
                              "Bio",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18, color: Colors.redAccent),
                            ),
                            SizedBox(width: 40),
                            Expanded(  // Utilisation de Expanded ici
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InputPage(text: "Modifiez votre bio", limit: 100,),
                                    ),
                                  );

                                  if (result != null) {
                                    bioController.text = result;
                                    bio = result;
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey5,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    bio,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25,),
                        Container(color: CupertinoColors.systemGrey4, width: double.infinity, height: 1.5,),
                        const SizedBox(height: 15,),
                      ],
                    ),
                  )
      ),
      )
      )
          ]
      )
    )
    );
  }
}
