// Remove the following line, as 'dart:js_util' is not needed for mobile apps
// import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Models/directory_model.dart';
import 'package:learnizer/Views/Visualize/Individual/view_directory.dart';

import '../../Models/task_model.dart';
import '../../Models/user_model.dart';
import 'package:intl/intl.dart';



class AddTaskPage extends StatefulWidget {
  final UserModel user;
  final int directory;
  const AddTaskPage({required this.user,required this.directory, Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage>{
  final _database = FirebaseFirestore.instance;
  final double coverHeight = 210;
  final double profileHeight = 144;
  late final _user = widget.user;
  late final _directory = widget.directory;
  String textDirectory = '';
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  String imageUrlLogo='';
  String imageUrlTask='';
  String? errorMessage;
  final myControllerName = TextEditingController();
  final myControllerDeadline = TextEditingController();
  final myControllerDescription = TextEditingController();
  final myControllerDirectory = TextEditingController();
  // This widget is the root of your application.
  Future<String> getThemeFromUtilities(String file, String caseImg) async {
    String imageUrl = await utilities.getTheme(file);
    if (caseImg == "cover") {
      imageUrlTask = imageUrl;
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
                              colors: utilities.getCorrectColors(_user.theme)
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
                              const SizedBox(height: 30),
                              const Text(
                                'Add Task',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 50),
                              utilities.buildTextField(myControllerName,TextInputType.text,false,_user.theme, "Name", Icons.edit,60,1),
                              const SizedBox(height: 20),
                              utilities.buildTextField(myControllerDescription,TextInputType.text,false,_user.theme,"Description",Icons.text_snippet_outlined,240,6),
                              const SizedBox(height: 20),
                              utilities.buildTextField(myControllerDeadline,TextInputType.text,false,_user.theme, "Deadline(dd/MM/yyyy)", Icons.timer,60,1),
                              if (errorMessage != null)
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              buildAddTaskBtn()
                            ],
                          )
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

  buildTaskImage() {
    return CircleAvatar(
      radius: profileHeight / 1.8,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.white,
        child: ClipOval(
          child: Stack(
            children: [
              imageUrlTask.isNotEmpty
                  ? Image.network(
                imageUrlTask,
                width: profileHeight,
                height: profileHeight,
                fit: BoxFit.cover,
              )
                  : Container(),
              Positioned(
                top: profileHeight / 3.3, // Adjust this value to center vertically
                left: profileHeight / 3.3, // Adjust this value to center horizontally,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  color: utilities.returnColorByTheme(_user.theme),
                  onPressed: () async {
                    final imageUrl =
                    await utilities.pickImageFromGalleryOrCamera("camera");
                    setState(() {
                      imageUrlTask = imageUrl.toString();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  buildAddTaskBtn() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
                _addTask(myControllerName, myControllerDescription, myControllerDeadline,context);
              },
            style: OutlinedButton.styleFrom(
              // Customize the button style here
              side: const BorderSide(width: 2, color: Colors.white),
              foregroundColor: Colors.white, // Text color// Elevation (shadow)
            ),
            child: const Text('ADD TASK',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
        )
    );
  }

  _addTask(TextEditingController myControllerName, TextEditingController myControllerDescription, TextEditingController myControllerDeadline, context) async {
    final String name = myControllerName.text.trim();
    final String description = myControllerDescription.text.trim();
    final String deadline = myControllerDeadline.text.trim();
    DateFormat format = DateFormat("dd/MM/yyyy");
    final DateTime deadlineDate = format.parse(deadline);

    if (errorMessage == null) {
      try {
        TaskModel task = TaskModel(name: name, description: description, deadline: deadlineDate,attachments: []);
        _user.directories.elementAt(_directory).tasks.add(task);
        utilities.updateUserData(_user);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDirectoryPage(user: _user,directoryIndex: _directory),
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
    myControllerDirectory.clear();
    myControllerName.clear();
    myControllerDeadline.clear();
    myControllerDescription.clear();
  }

}

