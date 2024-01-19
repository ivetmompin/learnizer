import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Views/Add/add_task.dart';
import '../../../Models/user_model.dart';


class ViewTaskPage extends StatefulWidget {
  final UserModel user;
  final int directoryIndex;
  final int taskIndex;
  const ViewTaskPage({required this.user,required this.directoryIndex,required this.taskIndex, Key? key}) : super(key: key);

  @override
  State<ViewTaskPage> createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage>{
  final _database = FirebaseFirestore.instance;
  final double coverHeight = 210;
  final double profileHeight = 144;
  late final _user = widget.user;
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  String imageUrlLogo='';
  String imageUrlCover='';
  String? errorMessage;
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

  _deleteTask(String name) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("userDatabase")
        .where("Name", isEqualTo: _user.name)
        .get();

    // Check if there's a document with the given name
    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document in the result (assuming there's only one match)
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      // Delete the document by its ID
      await FirebaseFirestore.instance.collection("userDatabase").doc(
          documentSnapshot.id).delete();
    }
  }

}

