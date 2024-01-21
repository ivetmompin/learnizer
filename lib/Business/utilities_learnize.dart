
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnizer/Models/user_model.dart';

class UtilitiesLearnizer {

  Future pickImageFromGalleryOrCamera(String source) async {
    XFile? returnedImage;
    ImagePicker imagePicker = ImagePicker();if(source=="gallery") {
      returnedImage = await imagePicker.pickImage(
          source: ImageSource.gallery);
    }else if(source=="camera"){
      returnedImage = await imagePicker.pickImage(
          source: ImageSource.camera);
    }
    print('${returnedImage?.path}');

    if(returnedImage==null) return;

    String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try{
      await referenceImageToUpload.putFile(File(returnedImage.path));
      return await referenceImageToUpload.getDownloadURL();
    }catch(error){
      //some error
    }
  }

  Future<String> getTheme(String file) async {
    String url='';
    try {
      Reference ref = FirebaseStorage.instance.ref().child('Themes/$file');
      url = await ref.getDownloadURL();
      print("value of url: $url");
    } catch (e) {
      // Handle errors (e.g., file not found)
      print('Error getting image URL: $e');
    }
    return url;
  }

  Color returnColorByTheme(String? theme){
    switch(theme){
      case "pink": return const Color(0xffc64b8c);
      case "purple": return const Color(0xff57026f);
      case "green": return const Color(0xff3bb143);
      case "yellow": return const Color(0xffffbf00);
      case "orange": return const Color(0xffff5f00);
      default: return const Color(0xff6CCBCA);
    }
  }


  List<Color> getCorrectColors(String? selectedTheme) {
    switch(selectedTheme) {
      case "pink": return [ const Color(0x66c64b8c), const Color(0x99c64b8c), const Color(0xccc64b8c), const Color(0xFFc64b8c)];
      case "purple": return [ const Color(0x6657026f), const Color(0x9957026f), const Color(0xcc57026f), const Color(0xFF57026f)];
      case "green": return [const Color(0x663bb143), const Color(0x993bb143), const Color(0xcc3bb143), const Color(0xFF3bb143)];
      case "yellow": return [const Color(0x66ffbf00), const Color(0x99ffbf00), const Color(0xccffbf00), const Color(0xFFffbf00)];
      case "orange": return [const Color(0x66ff5f00), const Color(0x99ff5f00), const Color(0xccff5f00), const Color(0xFFff5f00)];
      default: return [const Color(0x666CCBCA), const Color(0x996CCBCA), const Color(0xcc6CCBCA), const Color(0xFF6CCBCA)];
    }
  }

  Column buildTextField(TextEditingController controller, TextInputType type, bool obscureText, String theme, String name, IconData icon, double height, int maxlines){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
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
            height: height,
            child: TextField(
              controller: controller,
              maxLines: maxlines,
              obscureText: obscureText,
              keyboardType: type,
              style: const TextStyle(
                  color: Colors.black87
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                      icon,
                      color: returnColorByTheme(theme),
                  ),
                  hintText: name,
                  hintStyle: TextStyle(
                      color: Colors.black38
                  )
              ),
            )
        )
      ],
    );
  }
  Container buildOutlinedButton(String theme, String name, dynamic onPressedFunction){
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {onPressedFunction;},
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

  updateUserData(UserModel user) async {
    final CollectionReference userCollection = FirebaseFirestore.instance.collection("userDatabase");

    // Assuming there is a unique identifier for each user, like the user's email
    final DocumentReference userDocument = userCollection.doc(user.email);

    await userDocument.set(user.toJson());
  }

  deleteUserData(UserModel user) async {
    FirebaseFirestore database = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("userDatabase")
        .where("Name", isEqualTo: user.name)
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
