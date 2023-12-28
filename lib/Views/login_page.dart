import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Views/sign_up.dart';
import 'package:learnizer/Views/user_menu.dart';

import '../Models/user_model.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final _database = FirebaseFirestore.instance;
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
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x666CCBCA),
                                Color(0x996CCBCA),
                                Color(0xcc6CCBCA),
                                Color(0xFF6CCBCA),
                              ]
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
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 50),
                              buildEmail(myControllerEmail),
                              const SizedBox(height: 20),
                              buildPassword(myControllerPassword),
                              buildNoAccountButton(),
                              if (errorMessage != null)
                                Text(
                                  errorMessage!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              buildLogInBtn(),
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

  buildNoAccountButton(){
    return Container(
      alignment: Alignment.centerRight,
      child: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't you have an account? ",style: TextStyle(
                  color: CupertinoColors.white,)),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text("Sign Up", style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold),)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildLogInBtn(){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
        onPressed: () { if (
        !emailRegex.hasMatch(myControllerEmail.text)) {
          setState(() {
            errorMessage = 'Please provide a valid email';
          });
        } else {
          // Reset errors when the email is entered properly
          setState(() {
            errorMessage = null;
          });
        }
        // All fields are valid
        _signInUser(
            myControllerEmail, myControllerPassword, context); },
        style: OutlinedButton.styleFrom(
          // Customize the button style here
          side: const BorderSide(width: 2, color: Colors.white),
          foregroundColor: Colors.white, // Text color// Elevation (shadow)
        ),
        child: const Text('LOGIN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          )
        ),
      ),
      )
    );
  }

  _signInUser(TextEditingController myControllerEmail,
      TextEditingController myControllerPassword, context) async {
    final String email = myControllerEmail.text.trim();
    final String password = myControllerPassword.text.trim();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      QuerySnapshot snapshot = await _database.collection("userDatabase").where("Email", isEqualTo: email).get();
      // Check if there's a document with the given name
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = snapshot.docs.first;
        UserModel userModel = UserModel.fromSnapshot(documentSnapshot as DocumentSnapshot<Map<String, dynamic>>);
        // Now you can use the 'user' object

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserMenuPage(user: userModel),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        setState(() {
          errorMessage = 'Invalid password';
        });
      } else if (e.code == 'user-not-found') {
        setState(() {
          errorMessage = 'No user found with that email';
        });
      } else if (e.code == 'too-many-requests') {
        setState(() {
          errorMessage = 'Too many login attempts. Please try again later.';
        });
      } else {
        setState(() {
          errorMessage = 'An error occurred: $e';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred: $e';
      });
    }
    myControllerEmail.clear();
    myControllerPassword.clear();
  }

}

