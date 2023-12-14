import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{

  final _themeImages= FirebaseStorage.instance;
  final double coverHeight = 280;
  String imageUrl='';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 0.0, right: 24),
          child: Text("Recipe Details", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 24,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
        Container(
        color: Colors.grey,
        child: Image.network(imageUrl,
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
          ),
        ),
        ],
      ),
    );
  }
}
