import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jymu/screens/home/components/Notification.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  static String routeName = "/";

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  bool i = true;
  String nom = "Hugo Vincent";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              sliver: SliverToBoxAdapter(
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
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const DefaultTextStyle(
                          style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w700, fontSize: 29),
                          child: Text("Notifications ",),
                        ),
                        Image.asset("assets/images/emoji_bell.png", height: 30,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w600, fontSize: 16),
                      child: Text("Cette semaine"),
                    ),
                    Icon(CupertinoIcons.time, color: Color(0xff37085B), size: 18,)
                  ],
                ),
                SizedBox(height: 20),
                Notification1(),
                SizedBox(height: 20),
                Notification1(),
                SizedBox(height: 20),
                Notification1(),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(color: Color(0xff37085B), fontWeight: FontWeight.w600, fontSize: 16),
                      child: Text("Plus tôt ce mois-ci"),
                    ),
                    Icon(CupertinoIcons.time, color: Color(0xff37085B), size: 18,)
                  ],
                ),
                SizedBox(height: 20),
                Notification1(),
                SizedBox(height: 20),
                Notification1(),
                SizedBox(height: 20),
                Notification1(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
