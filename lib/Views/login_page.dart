import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
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
        child: Image.network(_recipe.image,
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
