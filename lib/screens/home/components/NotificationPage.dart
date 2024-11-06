import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:jymu/Models/NotificationService.dart';
import 'package:jymu/Models/UserModel.dart';
import 'package:jymu/screens/home/NotifListComp.dart';
import 'package:jymu/screens/home/components/Notification.dart';
import 'package:jymu/screens/home/settings/NotifiSettings.dart';
import 'package:preload_page_view/preload_page_view.dart';


const Color inActiveIconColor = Color(0xFFB6B6B6);

class NotificationPage extends StatefulWidget {
  final PreloadPageController pg;
  const NotificationPage({super.key, required this.pg});

  static String routeName = "/";

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _numOldNotifsToShow = 0;
  final ScrollController _scrollController = ScrollController();

 @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF3F5F8),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: UserModel.currentUser().notificationsloader,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CupertinoActivityIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else if (StoredNotification().notifs.isEmpty) {
                return FutureBuilder<void>(
                  future: UserModel.currentUser().notificationsloader,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CupertinoActivityIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    } else if (StoredNotification().notifs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
                                child: GestureDetector(
                                  onTapUp: (t){
                                  },
                                  child: Image.asset("assets/images/emoji_bell.png", height: 28,),
                                )
                            ),
                            SizedBox(height: 15,),
                            GestureDetector(
                              onTapUp: (t){
                                FirebaseAuth.instance.signOut();
                              },
                              child: DefaultTextStyle(
                                style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 15),
                                child: Text("Tu n'as pas de notifications !"),
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    final notifications = StoredNotification().notifs;

                    bool isSameDay(DateTime date1, DateTime date2) {
                      return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
                    }

                    final today = DateTime.now();
                    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

                    final todayNotifications = notifications.where((notif) {
                      final notifDate = notif.timestamp.toDate();
                      return isSameDay(notifDate, today);
                    }).toList();

                    final thisWeekNotifications = notifications.where((notif) {
                      final notifDate = notif.timestamp.toDate();
                      return notifDate.isAfter(startOfWeek) && !isSameDay(notifDate, today);
                    }).toList();

                    final olderNotifications = notifications.where((notif) {
                      final notifDate = notif.timestamp.toDate();
                      return notifDate.isBefore(startOfWeek);
                    }).toList();

                    return ListView.builder(
                      itemCount: todayNotifications.length + thisWeekNotifications.length + olderNotifications.length +
                          (todayNotifications.isNotEmpty ? 1 : 0) +
                          (thisWeekNotifications.isNotEmpty ? 1 : 0) +
                          (olderNotifications.isNotEmpty ? 1 : 0),
                      itemBuilder: (context, index) {
                        int itemIndex = 0;

                        if (todayNotifications.isNotEmpty && index == itemIndex) {
                          return Padding(
                            padding: EdgeInsets.only(left: 15, top: MediaQuery.of(context).size.height*0.07),
                            child: Text(
                              "Aujourd'hui",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        itemIndex += todayNotifications.isNotEmpty ? 1 : 0;

                        if (index >= itemIndex && index < itemIndex + todayNotifications.length) {
                          final notification = todayNotifications[index - itemIndex];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: NotifListComp(notif: notification),
                          );
                        }
                        itemIndex += todayNotifications.length;

                        if (thisWeekNotifications.isNotEmpty && index == itemIndex) {
                          return Padding(
                              padding: EdgeInsets.only(left: 15,right: 15, bottom: 10, top: todayNotifications.isEmpty ? MediaQuery.of(context).size.height*0.07: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(!todayNotifications.isEmpty)
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: Colors.black.withOpacity(0.07),
                                      ),
                                    if(!todayNotifications.isEmpty)
                                      SizedBox(height: 10,),
                                    Text(
                                      "Cette semaine",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ]
                              )
                          );
                        }
                        itemIndex += thisWeekNotifications.isNotEmpty ? 1 : 0;

                        if (index >= itemIndex && index < itemIndex + thisWeekNotifications.length) {
                          final notification = thisWeekNotifications[index - itemIndex];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: NotifListComp(notif: notification),
                          );
                        }
                        itemIndex += thisWeekNotifications.length;

                        if (olderNotifications.isNotEmpty && _numOldNotifsToShow < olderNotifications.length && index == itemIndex) {
                          return Padding(
                              padding: EdgeInsets.only(left: 15,right: 15, bottom: 10, top: todayNotifications.isEmpty ? MediaQuery.of(context).size.height*0.07: 10),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.black.withOpacity(0.07),
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Plus anciennes",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTapUp: (t) {
                                          setState(() {
                                            if(olderNotifications.isNotEmpty){
                                              _numOldNotifsToShow += 5;
                                            }
                                          });
                                        },
                                        child: Container(
                                            width: 120,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.circular(12)
                                            ),
                                            child: Center(
                                              child: Text('Charger plus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                          );
                        }
                        itemIndex += olderNotifications.isNotEmpty && _numOldNotifsToShow < olderNotifications.length ? 1 : 0;

                        if (index >= itemIndex && index < itemIndex + _numOldNotifsToShow) {
                          final notification = olderNotifications[index - itemIndex];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: NotifListComp(notif: notification),
                          );
                        }

                      },
                    );
                  },
                );
              }

              final notifications = StoredNotification().notifs;

              bool isSameDay(DateTime date1, DateTime date2) {
                return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
              }

              final today = DateTime.now();
              final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

              final todayNotifications = notifications.where((notif) {
                final notifDate = notif.timestamp.toDate();
                return isSameDay(notifDate, today);
              }).toList();

              final thisWeekNotifications = notifications.where((notif) {
                final notifDate = notif.timestamp.toDate();
                return notifDate.isAfter(startOfWeek) && !isSameDay(notifDate, today);
              }).toList();

              final olderNotifications = notifications.where((notif) {
                final notifDate = notif.timestamp.toDate();
                return notifDate.isBefore(startOfWeek);
              }).toList();

              return ListView.builder(
                itemCount: todayNotifications.length + thisWeekNotifications.length + olderNotifications.length +
                    (todayNotifications.isNotEmpty ? 1 : 0) +
                    (thisWeekNotifications.isNotEmpty ? 1 : 0) +
                    (olderNotifications.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  int itemIndex = 0;

                  if (todayNotifications.isNotEmpty && index == itemIndex) {
                    StoredNotification().tday = true;
                    return Padding(
                      padding: EdgeInsets.only(left: 15, top: MediaQuery.of(context).size.height*0.07),
                      child: Text(
                        "Aujourd'hui",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6)),
                      ),
                    );
                  }
                  itemIndex += todayNotifications.isNotEmpty ? 1 : 0;

                  if (index >= itemIndex && index < itemIndex + todayNotifications.length) {
                    final notification = todayNotifications[index - itemIndex];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: NotifListComp(notif: notification),
                    );
                  }
                  itemIndex += todayNotifications.length;

                  if (thisWeekNotifications.isNotEmpty && index == itemIndex) {
                    return Padding(
                        padding: EdgeInsets.only(left: 15,right: 15, bottom: 10, top: todayNotifications.isEmpty ? MediaQuery.of(context).size.height*0.07: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(!todayNotifications.isEmpty)
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.black.withOpacity(0.07),
                                ),
                              if(!todayNotifications.isEmpty)
                                SizedBox(height: 10,),
                              Text(
                                "Cette semaine",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6)),
                              ),
                            ]
                        )
                    );
                  }
                  itemIndex += thisWeekNotifications.isNotEmpty ? 1 : 0;

                  if (index >= itemIndex && index < itemIndex + thisWeekNotifications.length) {
                    final notification = thisWeekNotifications[index - itemIndex];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: NotifListComp(notif: notification),
                    );
                  }
                  itemIndex += thisWeekNotifications.length;

                  if(todayNotifications.isEmpty && thisWeekNotifications.isEmpty && index == itemIndex){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
                            child: GestureDetector(
                              onTapUp: (t){
                              },
                              child: Image.asset("assets/images/emoji_bell.png", height: 28,),
                            )
                        ),
                        SizedBox(height: 15,),
                        GestureDetector(
                          onTapUp: (t){},
                          child: DefaultTextStyle(
                            style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 15),
                            child: Text("Pas de notifications récentes"),
                          ),
                        )
                      ],
                    );
                  }

                  if (olderNotifications.isNotEmpty && _numOldNotifsToShow < olderNotifications.length && index == itemIndex) {
                    return Padding(
                        padding: EdgeInsets.only(left: 15,right: 15, bottom: 10, top: todayNotifications.isEmpty ? MediaQuery.of(context).size.height*0.07: 10),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.black.withOpacity(0.07),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Plus anciennes",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6)),
                                ),
                                GestureDetector(
                                  onTapUp: (t) {
                                    setState(() {
                                      if(olderNotifications.isNotEmpty){
                                        _numOldNotifsToShow += 5;
                                      }
                                    });
                                  },
                                  child: Container(
                                      width: 120,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Center(
                                        child: Text('Charger plus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),),
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    );
                  }
                  itemIndex += olderNotifications.isNotEmpty && _numOldNotifsToShow < olderNotifications.length ? 1 : 0;

                  if (index >= itemIndex && index < itemIndex + _numOldNotifsToShow) {
                    final notification = olderNotifications[index - itemIndex];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: NotifListComp(notif: notification),
                    );
                  }

                },
              );
            },
          ),

          GlassContainer(
            height: MediaQuery.of(context).size.height*0.12,
            color: Color(0xFFF3F5F8).withOpacity(0.7),
            blur: 10,
            child: Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05, bottom: 10, left: MediaQuery.of(context).size.width*0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: GestureDetector(
                          onTapUp: (t){
                            widget.pg.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                          },
                          child: Icon(Icons.arrow_back_ios_new, color: Colors.black.withOpacity(0.6), size: 18,),
                        ),
                      ),

                      SizedBox(width: 15,),
                      Text(
                        "Notifications",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Colors.black.withOpacity(0.8)
                        ),
                      ),
                      SizedBox(width: 10,),
                      Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: FutureBuilder<void>(
                          future: UserModel.currentUser().notificationsloader,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox();
                            } else if (snapshot.hasError) {
                              return SizedBox();
                            } else if ((StoredNotification().nabo + StoredNotification().ncom + StoredNotification().nlike) == 0) {
                              return Container(
                                  height: 25,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Colors.redAccent
                                  ),
                                  child: Center(
                                    child: Text(
                                      "0",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              );
                            }

                            return Container(
                                height: 25,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.redAccent
                                ),
                                child: Center(
                                  child: Text(
                                    (StoredNotification().nabo + StoredNotification().ncom + StoredNotification().nlike) < 10 ? (StoredNotification().nabo + StoredNotification().ncom + StoredNotification().nlike).toString(): "9+",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white
                                    ),
                                  ),
                                )
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: GestureDetector(
                      onTapUp: (t){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotifSettings(),
                          ),
                        );
                      },
                      child: Icon(CupertinoIcons.slider_horizontal_3, color: Colors.black.withOpacity(0.7), size: 22,),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
