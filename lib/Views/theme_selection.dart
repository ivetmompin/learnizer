import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Models/theme_model.dart';
import 'package:learnizer/Views/user_menu.dart';


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
  final double profileHeight = 144;
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  String imageUrlLogo='';
  String selectedTheme='';
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
    userEmail = widget.userEmail;
    // Fetch image URLs when the widget is initialized
    getThemeFromUtilities("learnizer.png");
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
                    child:SingleChildScrollView(
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
                              'Select Your Theme Color',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 50),
                            buildColorsContainer(),
                            const SizedBox(height: 20),
                            buildSelectBtn(),
                            if (errorMessage != null)
                              Text(
                                errorMessage!,
                                style: TextStyle(color: Colors.red),
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

  buildLogoImage(){
    getThemeFromUtilities("learnizer.png");
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

  buildSelectBtn(){
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
            _saveTheme(selectedTheme, context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserMenuPage(),
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

  _saveTheme(String theme, context) async {
    try {

      ThemeModel themeModel = ThemeModel(email: userEmail, theme: selectedTheme);
      await _database.collection("Themes").add(themeModel.toJson());

      // Clear text fields after successful addition
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe created successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Handle errors
      print('Error creating recipe: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error creating recipe'),
          duration: Duration(seconds: 2),
        ),
      );
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
                padding: EdgeInsets.all(9.0),
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
              padding: EdgeInsets.all(2.0),
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