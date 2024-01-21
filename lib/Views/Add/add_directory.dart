import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Models/task_model.dart';

import '../../Models/directory_model.dart';
import '../../Models/user_model.dart';
import '../Visualize/user_menu.dart';

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
  String imageUrlDirectory='';
  String? errorMessage;
  final myControllerName = TextEditingController();
  // This widget is the root of your application.
  Future<String> getThemeFromUtilities(String file, String caseImg) async {
    String imageUrl = await utilities.getTheme(file);
    if (caseImg == "cover") {
      imageUrlDirectory = imageUrl;
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
                              buildUserImage(),
                              const SizedBox(height: 30),
                              utilities.buildTextField(myControllerName, TextInputType.text, false,_user.theme, "Name", Icons.edit, 60, 1),
                              const SizedBox(height: 30),
                              buildAddDirectoryBtn()
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

  buildAddDirectoryBtn(){
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _addDirectory(myControllerName, context);
            },
            child: const Text('ADD DIRECTORY',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
        )
    );
  }

  buildUserImage() {
    return CircleAvatar(
      radius: profileHeight / 1.8,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.white,
        child: ClipOval(
          child: Stack(
            children: [
              imageUrlDirectory.isNotEmpty
                  ? Image.network(
                imageUrlDirectory,
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
                    await utilities.pickImageFromGalleryOrCamera("gallery");
                    setState(() {
                      imageUrlDirectory = imageUrl.toString();
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

_addDirectory(TextEditingController myControllerName, context) async {
  final String name = myControllerName.text.trim();
  final List<TaskModel> tasks = [];

  if (errorMessage == null) {
    try {
      DirectoryModel directoryModel = DirectoryModel(name: name, image: imageUrlDirectory, tasks:tasks);
      _user.directories.add(directoryModel);
      utilities.updateUserData(_user);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserMenuPage(user: _user),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    }
  }
  myControllerName.clear();
}

}

