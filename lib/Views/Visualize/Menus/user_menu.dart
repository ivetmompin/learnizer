import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Models/directory_model.dart';
import 'package:learnizer/Views/Add/add_directory.dart';
import "package:learnizer/Views/Visualize/Menus/NavBar.dart";

import '../../../Models/user_model.dart';
import '../Individual/view_directory.dart';


class UserMenuPage extends StatefulWidget {
  final UserModel user;
  const UserMenuPage({required this.user, Key? key}) : super(key: key);
  @override
  State<UserMenuPage> createState() => _UserMenuPageState();
}

class _UserMenuPageState extends State<UserMenuPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final userLoggedIn = FirebaseAuth.instance.currentUser;
  String imageUrlTheme = "";
  final double coverHeight = 210;
  final double profileHeight = 144;
  int myCurrentIndex=0;
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  late final UserModel _user=widget.user;
  String? errorMessage;

  getThemeFromUtilities(String file) async {
      imageUrlTheme = await utilities.getTheme(file);
  }

  @override
  void initState() {
    super.initState();
    // Fetch image URLs and user data when the widget is initialized
    Future.delayed(Duration.zero, () async {
      await getThemeFromUtilities("${_user.theme}.jpg");
    });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: null,
        drawer: NavBar(user: _user),
        backgroundColor: Colors.transparent,
        body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.topCenter,
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
                  vertical: 80,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                onPressed: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                },
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  weight: 9,
                                  size: 30, // Set the size of the icon to make it bigger
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                weight: 9,
                                size: 30, // Set the size of the icon to make it bigger
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddDirectoryPage(user: _user),
                                  ),
                                );
                              },
                            ),
                          ]
                      ),
                          const SizedBox(height: 45),
                          Text(
                            'Welcome ${_user.name}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Your folders',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 40),
                          setContent()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  setContent(){
    if (_user.directories.isNotEmpty) {
      return CarouselSlider.builder(
        options: CarouselOptions(
          autoPlay: false,
          height: MediaQuery.of(context).size.width / 0.9,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
        ),
        itemCount: _user.directories.length,
        itemBuilder: (context,index,realIndex){
          myCurrentIndex = index;
          final directory = _user.directories.elementAt(index);
          return buildFolder(directory);
        },
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.all(5),
        height: MediaQuery.of(context).size.width / 0.9,
        width: double.infinity,
        color: utilities.returnColorByTheme(_user.theme),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You have no directories",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDirectoryPage(user: _user),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: utilities.returnColorByTheme(_user.theme), backgroundColor: Colors.white, // Change text color
              ),
              child: const Text("Create a Directory"),
            ),
          ],
        ),
      );
    }
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

  buildFolder(DirectoryModel directory) {
    String imageUrlToShow='';
    if(directory.image.isNotEmpty){
      imageUrlToShow = directory.image;
    }else {
      imageUrlToShow = imageUrlTheme;
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDirectoryPage(user: _user,directoryIndex: _user.directories.indexOf(directory)),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(2.0),
        margin: const EdgeInsets.all(5),
        height: double.infinity,
        width: double.infinity,
        color: utilities.returnColorByTheme(_user.theme),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: Colors.grey,
              child: CachedNetworkImage(
                imageUrl: imageUrlToShow,
                placeholder: (context, ima) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: double.infinity,
                height: coverHeight,
                fit: BoxFit.cover,
              ),
            ),
            // Text Fields
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  directory.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
