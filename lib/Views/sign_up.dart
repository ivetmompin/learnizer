import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Views/theme_selection.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{
  final double coverHeight = 210;
  final double profileHeight = 144;
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  String imageUrlLogo='';
  String imageUrlCover='';
  String? errorMessage;
  final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  final myControllerEmail = TextEditingController();
  final myControllerPassword = TextEditingController();
  final myControllerConfirmation = TextEditingController();
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
                              colors: utilities.getCorrectColors("blue"),
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
                              utilities.buildTextField(myControllerEmail, TextInputType.emailAddress, false, "blue", "Email", Icons.email,60,1),
                              const SizedBox(height: 20),
                              utilities.buildTextField(myControllerPassword, TextInputType.text, true, "blue", "Password", Icons.lock,60,1),
                              const SizedBox(height: 20),
                              utilities.buildTextField(myControllerConfirmation, TextInputType.text, true, "blue", "Password Confirmation", Icons.verified_user_rounded,60,1),
                              const SizedBox(height: 20),
                              if (errorMessage != null)
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              buildSignUpBtn(),
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

  buildSignUpBtn(){
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              if (!emailRegex.hasMatch(myControllerEmail.text)) {
                setState(() {
                  errorMessage = 'Please provide a valid email';
                });
              } else
              if (myControllerPassword.text != myControllerConfirmation.text) {
                setState(() {
                  errorMessage = 'Passwords do not match';
                });
              } else {
                setState(() {
                  errorMessage = null;
                });
              }
              // All fields are valid
              _signUpUser(myControllerEmail, myControllerPassword,
                  myControllerConfirmation, context);
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

  _signUpUser(TextEditingController myControllerEmail, TextEditingController myControllerPassword, TextEditingController myControllerConfirmation, context) async {
    final String email = myControllerEmail.text.trim();
    final String password = myControllerPassword.text.trim();

    if (errorMessage == null) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
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

