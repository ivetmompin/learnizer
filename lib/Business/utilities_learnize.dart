
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    print('file: '+file);
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
      case "pink": return const Color(0xF9670137);
      case "purple": return const Color(0xFF57026f);
      case "green": return const Color(0xFF015407);
      case "yellow": return const Color(0xFF644B01);
      case "orange": return const Color(0xFA7A2E01);
      default: return const Color(0xff018582);
    }
  }


  List<Color> getCorrectColors(String? selectedTheme) {
    switch(selectedTheme) {
      case "pink": return [
        const Color(0xF9850247),
        const Color(0xccc64b8c),
        const Color(0xccc64b8c),
        const Color(0xF9850247)
      ];
      case "purple": return [
        const Color(0xff57026f),
        const Color(0x99da63fc),
        const Color(0x99da63fc),
        const Color(0xff57026f),
      ];
      case "green": return [
        const Color(0xff015407),
        const Color(0xcc56e360),
        const Color(0xcc56e360),
        const Color(0xff015407),
      ];
      case "yellow": return [
        const Color(0xFF886601),
        const Color(0xfff6cf59),
        const Color(0xfff6cf59),
        const Color(0xFF886601),
      ];
      case "orange": return [
        const Color(0xFAA83F01),
        const Color(0xfff6823d),
        const Color(0xfff6823d),
        const Color(0xFAA83F01),
      ];
      default: return [
        const Color(0xFF006966),
        const Color(0xcc2ef0f6),
        const Color(0xcc2ef0f6),
        const Color(0xFF006966),];
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
      User? user = FirebaseAuth.instance.currentUser;
      if(user!=null){
        user.delete();
      }
    }
  }
}
