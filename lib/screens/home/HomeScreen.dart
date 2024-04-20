import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jymu/screens/home/components/banner_exercices.dart';
import 'package:jymu/Alexis/exemple.dart';
import 'package:jymu/screens/home/components/home_banner.dart';
import 'package:jymu/screens/home/components/training_home.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = "/";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SuperScaffold(
          appBar: SuperAppBar(
            title: Text("Home - Entrainement"),
            largeTitle: SuperLargeTitle(
              enabled: false,
              largeTitle: "Welcome",
            ),

            searchBar: SuperSearchBar(
              enabled: true,
              placeholderText: "Cherche un exercice",
              cancelButtonText: "Annuler",
              onChanged: (query) {
                // Search Bar Changes
              },
              onSubmitted: (query) {
                // On Search Bar submitted
              },
              searchResult: ExoBanner(),
                // Add other search bar properties as needed
              ),
          bottom: SuperAppBarBottom(
            enabled: false,
            height: 40,
            child: BanniereHome(), // Any widget of yours
          ),
        ),
        body: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Exemple(),
              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text("Entrainement", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87), textAlign: TextAlign.start, ),
              ),
              TrainingComp(),
              SizedBox(height: 40,),
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text("Nutrition", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87), textAlign: TextAlign.start, ),
              ),
              TrainingComp(),
            ],
          ),
        ),
      )
    );
  }
}
