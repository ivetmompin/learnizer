import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Models/directory_model.dart';
import 'package:learnizer/Models/user_model.dart';
import 'package:learnizer/Views/Visualize/user_menu.dart';


class ThemeSelectionPage extends StatefulWidget {
  final String userEmail;
  const ThemeSelectionPage({required this.userEmail, Key? key}) : super(key: key);

  @override
  State<ThemeSelectionPage> createState() => _ThemeSelectionPageState();
}
class _ThemeSelectionPageState extends State<ThemeSelectionPage> {
  late String userEmail;
  final _database = FirebaseFirestore.instance;
  final double coverHeight = 210;
  final double profileHeight = 124;
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  final myUsernameController = TextEditingController();
  String imageUrlUser='';
  String imageUrlLogo='';
  String selectedTheme='';
  String? errorMessage;
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    userEmail = widget.userEmail;
    // Fetch image URLs when the widget is initialized
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
                            colors: utilities.getCorrectColors(selectedTheme),
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
                              buildUsername(myUsernameController),
                              const SizedBox(height: 30),
                              const Text(
                                'Select Your Theme Color',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              buildColorsContainer(),
                              const SizedBox(height: 20),
                              buildSelectBtn(),
                              if (errorMessage != null)
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              // buildLogInBtn(),
                            ],
                          )
                      )
                  )
                ],
              );
            },
        ),
      ),
    );
  }

  Future<String> getThemeFromUtilities(String file) async {
    String imageUrl = await utilities.getTheme(file);
    imageUrlLogo = imageUrl;
    return imageUrl;
  }

  buildLogoImage() {
    return CircleAvatar(
      radius: profileHeight / 1.8,
      backgroundColor: Colors.transparent,
      child: CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Image.network(
            imageUrlLogo, // Replace 'assets/learnizer.png' with the correct path
            width: profileHeight,
            height: profileHeight,
            fit: BoxFit.cover,
          ),
        ),
      ),
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
              imageUrlUser.isNotEmpty
                  ? Image.network(
                imageUrlUser,
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
                  color: utilities.returnColorByTheme(selectedTheme),
                  onPressed: () async {
                    final imageUrl =
                    await utilities.pickImageFromGalleryOrCamera("camera");
                    setState(() {
                      imageUrlUser = imageUrl.toString();
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

  buildUsername(TextEditingController controller){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Username',
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
              style: const TextStyle(
                  color: Colors.black87
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                      Icons.person,
                      color: utilities.returnColorByTheme(selectedTheme)
                  ),
                  hintText: 'Username',
                  hintStyle: const TextStyle(
                      color: Colors.black38
                  )
              ),
            )
        )
      ],
    );
  }

  buildSelectBtn(){
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () async {
            UserModel user = await _saveUser(imageUrlUser,myUsernameController,selectedTheme,context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserMenuPage(user: user),
              ),
            );
            },
            style: OutlinedButton.styleFrom(
              // Customize the button style here
              side: const BorderSide(width: 2, color: Colors.white),
              foregroundColor: Colors.white, // Text color// Elevation (shadow)
            ),
            child: const Text('SELECT',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
        )
    );
  }

  Future<UserModel> _saveUser(String imageUrlUser, TextEditingController myNameController, String theme, context) async {
    try {
      if(imageUrlUser.isEmpty){
        imageUrlUser=await utilities.getTheme("profile.png");
      }
      String name = myNameController.text.trim();
      List<DirectoryModel> directories = [];
      UserModel userModel = UserModel(email: userEmail, name: name, directories: directories, profileImage: imageUrlUser, theme: selectedTheme);
      await _database.collection("userDatabase").add(userModel.toJson());

      // Clear text fields after successful addition
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User created successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      return userModel;
    } catch (error) {
      // Handle errors
      print('Error creating user: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error creating user'),
          duration: Duration(seconds: 2),
        ),
      );
      return UserModel(email: "", name: "", directories: [], profileImage: "", theme: "");
    }
  }


  buildColorsContainer() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.width / 1.6,
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
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.all(9.0),
                children: [
                  getContainerPiece("blue"),
                  getContainerPiece("green"),
                  getContainerPiece("yellow"),

                  getContainerPiece("orange"),
                  getContainerPiece("pink"),
                  getContainerPiece("purple")
                ],
              ),
          )
        ],
      );
  }

  getContainerPiece(String color) {
    return CircleAvatar(
        radius: profileHeight/2,
        backgroundColor: Colors.transparent,
        child:CircleAvatar(
          radius: profileHeight/3, // Adjust the radius as needed
          backgroundColor: Colors.transparent, // Border color// Make sure the background is transparent
          child: ClipOval(
            child: Container(
              padding: const EdgeInsets.all(2.0),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: utilities.getCorrectColors(color),
                )
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedTheme=color;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Make the button background transparent
                  elevation: 0, // Remove the shadow
                ),
                child: const Text('',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ),
    );
  }
}