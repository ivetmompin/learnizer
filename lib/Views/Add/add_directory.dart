import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Models/task_model.dart';
import 'package:learnizer/Views/theme_selection.dart';

import '../../Models/user_model.dart';


class AddDirectoryPage extends StatefulWidget {
  final UserModel user;
  const AddDirectoryPage({required this.user, Key? key}) : super(key: key);

  @override
  State<AddDirectoryPage> createState() => _AddDirectoryPageState();
}

class _AddDirectoryPageState extends State<AddDirectoryPage>{
  final _database = FirebaseFirestore.instance;
  final double coverHeight = 210;
  final double profileHeight = 144;
  late final _user = widget.user;
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  String imageUrlLogo='';
  String imageUrlCover='';
  String? errorMessage;
  final myControllerName = TextEditingController();
  final myControllerDeadline = TextEditingController();
  final myControllerDescription = TextEditingController();
  // This widget is the root of your application.
  Future<String> getThemeFromUtilities(String file, String caseImg) async {
    String imageUrl = await utilities.getTheme(file);
    if (caseImg == "cover") {
      imageUrlCover = imageUrl;
    } else {
      imageUrlLogo = imageUrl;
    }
    return imageUrl;
  }

  @override
  void initState() {
    super.initState();
    // Fetch image URLs when the widget is initialized
    getThemeFromUtilities("learnizer.png", "logo");
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
              getThemeFromUtilities("learnizer.png", "logo"),
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
                              colors: utilities.getCorrectColors(_user.theme),
                          )
                      ),
                      child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 120
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildLogoImage(),
                              const SizedBox(height: 30),
                              const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 30),
                              utilities.buildTextField(myControllerName, _user.theme, "Name", Icons.edit),
                              const SizedBox(height: 20),
                              utilities.buildTextField(myControllerDescription,_user.theme,"Description",Icons.person),
                              const SizedBox(height: 20),
                              utilities.buildTextField(myControllerDeadline, _user.theme, "Deadline", Icons.timer),
                              const SizedBox(height: 30),
                              utilities.buildOutlinedButton(_user.theme, "Add Task", _addTask(myControllerName, myControllerDescription, myControllerDeadline, context))
                            ],
                          ),
                      )
                  )
                ],
              );
            }
        ),
      ),
    );
  }

  buildLogoImage(){
    getThemeFromUtilities("learnizer.png","logo");
    return CircleAvatar(
      radius: profileHeight/1.8,
      backgroundColor: Colors.transparent,
      child:CircleAvatar(
        radius: profileHeight/2, // Adjust the radius as needed
        backgroundColor: Colors.transparent, // Border color// Make sure the background is transparent
        child: ClipOval(
          child: Image.network(
            imageUrlLogo,
            width: profileHeight, // Adjust the width as needed
            height: profileHeight, // Adjust the height as needed
            fit: BoxFit.cover, // Make sure the image covers the circular boundary
          ),
        ),
      ),
    );
  }

_addTask(TextEditingController myControllerName, TextEditingController myControllerDescription, TextEditingController myControllerDeadline, context) async {
  final String name = myControllerName.text.trim();
  final String description = myControllerDescription.text.trim();
  final String deadline = myControllerDeadline.text.trim();
  final DateTime deadlineDate = DateTime.parse(deadline);

  if (errorMessage == null) {
    try {
      _database.collection("userDatabase").add(
      )
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ThemeSelectionPage(userEmail: email),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          errorMessage = 'The password provided is too weak.';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          errorMessage = 'This account already exists.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    }
  }
  myControllerEmail.clear();
  myControllerPassword.clear();
  myControllerConfirmation.clear();
}

}

