import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Views/Add/add_task.dart';

import '../Models/user_model.dart';
import 'Add/add_directory.dart';


class AddMenuPage extends StatefulWidget {
  final UserModel user;
  const AddMenuPage({required this.user, Key? key}) : super(key: key);
  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  late final UserModel _user = widget.user;
  final double coverHeight = 210;
  final double profileHeight = 144;
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  String imageUrlLogo='';
  String imageUrlCover='';
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
                            buildProfileImage(),
                            const SizedBox(height: 30),
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 50),
                            utilities.buildOutlinedButton(_user.theme, "Add Directory", goToWidget(AddDirectoryPage(user:_user))),
                            utilities.buildOutlinedButton(_user.theme, "Add Task", goToWidget(AddTaskPage(user:_user)))
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

  buildProfileImage() {
    return CircleAvatar(
      radius: profileHeight / 1.8,
      backgroundColor: Colors.transparent,
      child: CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Image.network(
            _user.profileImage,
            width: profileHeight,
            height: profileHeight,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  goToWidget(StatefulWidget route){
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => route,
      ),
    );
  }

}
