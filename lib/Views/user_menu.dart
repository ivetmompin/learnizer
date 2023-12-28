import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';

import '../Models/user_model.dart';
import 'add_menu.dart';


class UserMenuPage extends StatefulWidget {
  final UserModel user;
  const UserMenuPage({required this.user, Key? key}) : super(key: key);
  @override
  State<UserMenuPage> createState() => _UserMenuPageState();
}

class _UserMenuPageState extends State<UserMenuPage> {
  final _database = FirebaseFirestore.instance;
  final userLoggedIn = FirebaseAuth.instance.currentUser;
  String imageUrlLogo = "";
  final double coverHeight = 210;
  final double profileHeight = 144;
  int myCurrentIndex=0;
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  late final UserModel _user = widget.user;
  String? errorMessage;

  Future<String> getThemeFromUtilities(String file) async {
    String imageUrl = await utilities.getTheme(file);
    imageUrlLogo = imageUrl;
    return imageUrl;
  }

  @override
  void initState() {
    super.initState();
    // Fetch image URLs and user data when the widget is initialized
    Future.delayed(Duration.zero, () async {
      await getThemeFromUtilities("learnizer.png");
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
          future: getThemeFromUtilities("learnizer.png"),
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            // Check if the Future has completed
            if (snapshot.connectionState == ConnectionState.done) {
              // Render the UI once the Future is complete
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
                        colors: utilities.getCorrectColors(_user.theme),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 120,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: ElevatedButton(
                              onPressed: () { Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddMenuPage(user: _user),
                                ),
                              );},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(CircleBorder()),
                                padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                                backgroundColor: MaterialStateProperty.all(utilities.returnColorByTheme(_user.theme)), // <-- Button color
                                overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                  if (states.contains(MaterialState.pressed)) return Colors.red; // <-- Splash color
                                }),
                              ),
                              child: const Icon(Icons.add),
                            )),
                          const SizedBox(height: 25),
                          Text(
                            'Welcome ${_user.name}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Your folders',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CarouselSlider(options: CarouselOptions(
                            autoPlay: false,
                            height: MediaQuery.of(context).size.width / 0.9,
                            enlargeCenterPage: true,
                            aspectRatio: 2.0,
                            onPageChanged: (index,reason){
                              setState((){
                                myCurrentIndex=index;
                              });
                            }
                          ), items: getDirectories())
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // Return a loading indicator while waiting for the Future to complete
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  buildErrorText(){
    return Text('You have no folders',
      style: TextStyle(
        color: utilities.returnColorByTheme(_user.theme),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  buildFolder() {
    return Container(
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.all(5),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: utilities.getCorrectColors(_user.theme),
          )),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor:
          Colors.transparent, // Make the button background transparent
          elevation: 0, // Remove the shadow
        ),
        child: const Text(
          "Folder",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  getDirectories() {
    List<Container> containers = [];
    for(int i=0;i<4;i++){
     containers.add(buildFolder());
    }
    return containers;
  }
}
