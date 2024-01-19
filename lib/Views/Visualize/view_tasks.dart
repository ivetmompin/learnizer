import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Models/directory_model.dart';
import 'package:learnizer/Views/Add/add_task.dart';
import '../../Models/user_model.dart';


class ViewTasksPage extends StatefulWidget {
  final UserModel user;
  final int directory;
  const ViewTasksPage({required this.user, required this.directory, Key? key}) : super(key: key);

  @override
  State<ViewTasksPage> createState() => _ViewDirectoriesPageState();
}

class _ViewDirectoriesPageState extends State<ViewTasksPage>{
  final _database = FirebaseFirestore.instance;
  final double coverHeight = 210;
  final double profileHeight = 144;
  late final _user = widget.user;
  late final _directoryIndex = widget.directory;
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
                              Text(
                                '${_user.directories.elementAt(_directoryIndex).name} Tasks',
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

  buildEmail(TextEditingController controller){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 10),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0,2)
                  )
                ]
            ),
            height: 60,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                  color: Colors.black87
              ),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xFF6CCBCA)
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                      color: Colors.black38
                  )
              ),
            )
        )
      ],
    );
  }

  buildPassword(TextEditingController controller){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 10),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0,2)
                  )
                ]
            ),
            height: 60,
            child: TextField(
              controller: controller,
              obscureText: true,
              style: const TextStyle(
                  color: Colors.black87
              ),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                      Icons.lock,
                      color: Color(0xFF6CCBCA)
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                      color: Colors.black38
                  )
              ),
            )
        )
      ],
    );
  }

  buildPasswordConfirmation(TextEditingController controller){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Confirm Password',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 10),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0,2)
                  )
                ]
            ),
            height: 60,
            child: TextField(
              controller: controller,
              obscureText: true,
              style: const TextStyle(
                  color: Colors.black87
              ),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                      Icons.verified_user_rounded,
                      color: Color(0xFF6CCBCA)
                  ),
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(
                      color: Colors.black38
                  )
              ),
            )
        )
      ],
    );
  }

  buildAddTaskBtn(){
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // All fields are valid
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskPage(user: _user, directory: _directoryIndex,),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              // Customize the button style here
              side: const BorderSide(width: 2, color: Colors.white),
              foregroundColor: Colors.white, // Text color// Elevation (shadow)
            ),
            child: const Text('SIGN UP',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
        )
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewTasksPage(user: _user,directory: _directoryIndex),
        ),
      );
    }
  }

}

