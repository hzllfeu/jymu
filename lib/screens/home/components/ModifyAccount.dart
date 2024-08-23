import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jymu/UserManager.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class ModifyAccount extends StatefulWidget {
  final String? pp;
  final Map<String, dynamic> data;

  const ModifyAccount({super.key, required this.pp, required this.data});

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

  @override
  void initState() {
    super.initState();
    id = widget.data["id"];
    displayname = widget.data["displayname"];
    bio = widget.data["bio"];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            Container(
              width: 50,
              height: 6,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              children: [
                Text(
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
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.redAccent,
                      width: 0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        widget.pp ?? 'https://via.placeholder.com/150',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 25,),
                Text(
                  "Modifie ta photo de profil",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18, color: Colors.redAccent),
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
                  child: SizedBox(
                    height: 50,
                    child: CupertinoTextField(
                      controller: nameController,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      cursorColor: Colors.redAccent,
                      placeholder: displayname,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(12.0),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Text(
                  "Bio",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18, color: Colors.redAccent),
                ),
                SizedBox(width: 40),
                Expanded(  // Utilisation de Expanded ici
                  child: SizedBox(
                    height: 50,
                    child: CupertinoTextField(
                      controller: bioController,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      cursorColor: Colors.redAccent,
                      placeholder: bio,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25,),
            Container(color: CupertinoColors.systemGrey4, width: double.infinity, height: 1.5,),
            const SizedBox(height: 15,),


            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTapUp: (t) async {
                    if(!done){
                      String display = nameController.text.trim();
                      String tmpbio = bioController.text.trim();
                      //TODO verifier si bio et dsp name sont correct (taille etc)
                        if(display != displayname && !display.isEmpty){
                          await setDisplayName(id, display);
                        }
                        if(tmpbio != bio && !tmpbio.isEmpty){
                          await setBio(id, tmpbio);
                        }
                        setState(() {
                          done = true;
                        });

                    }
                  },
                  child: Container(
                    height: 70,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.redAccent,
                          Colors.deepOrange,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffF14BA9).withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(!done)
                          Text(
                            "Sauvegarder",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                          ),
                        if(!done)
                          SizedBox(width: 15,),
                        Icon(done ? CupertinoIcons.check_mark : CupertinoIcons.arrow_right, color: Colors.white, size: 20,)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
