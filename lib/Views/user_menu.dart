import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Models/theme_model.dart';


class UserMenuPage extends StatefulWidget {
  const UserMenuPage({super.key});

  @override
  State<UserMenuPage> createState() => _UserMenuPageState();
}

class _UserMenuPageState extends State<UserMenuPage>{
  final _database = FirebaseFirestore.instance;
  final userLoggedIn = FirebaseAuth.instance.currentUser;
  final double coverHeight = 210;
  final double profileHeight = 144;
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  String imageUrlLogo='';
  String theme='';
  String? errorMessage;
  // This widget is the root of your application.
  Future<String> getThemeFromUtilities(String file) async {
    String imageUrl = await utilities.getTheme(file);
    imageUrlLogo = imageUrl;
    return imageUrl;
  }

  @override
  void initState() {
    super.initState();
    // Fetch image URLs when the widget is initialized
    Future.delayed(Duration.zero, () async {
      await getThemeFromUtilities("learnizer.png");
      await _getTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: FutureBuilder(
          // Use FutureBuilder to wait for the image URLs
          future: Future.wait([
            getThemeFromUtilities("learnizer.png"),
            _getTheme()
          ]),
          builder: (context, snapshot) {
            // Render the UI once the image URLs are fetched
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: utilities.getCorrectColors(theme)
                        )
                    ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future _getTheme() async {
    final snapshot = await _database.collection("Themes").where("Email", isEqualTo: userLoggedIn?.email).get();
    final themes = snapshot.docs.map((e) => ThemeModel.fromSnapshot(e)).toList();
    theme = themes.first.theme;
  }

}

