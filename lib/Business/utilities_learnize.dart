
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      await referenceImageToUpload.putFile(File(returnedImage!.path));
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
      print("value of url: "+url);
    } catch (e) {
      // Handle errors (e.g., file not found)
      print('Error getting image URL: $e');
    }
    return url;
  }

  Color returnColorByTheme(String? theme){
    switch(theme){
      case "pink": return Color(0xffc64b8c);
      case "purple": return Color(0xff57026f);
      case "green": return Color(0xff3bb143);
      case "yellow": return Color(0xffffbf00);
      case "orange": return Color(0xffff5f00);
      default: return Color(0xff6CCBCA);
    }
  }


  List<Color> getCorrectColors(String? selectedTheme) {
    switch(selectedTheme) {
      case "pink": return [ Color(0x66c64b8c), Color(0x99c64b8c), Color(0xccc64b8c), Color(0xFFc64b8c)];
      case "purple": return [ Color(0x6657026f), Color(0x9957026f), Color(0xcc57026f), Color(0xFF57026f)];
      case "green": return [Color(0x663bb143), Color(0x993bb143), Color(0xcc3bb143), Color(0xFF3bb143)];
      case "yellow": return [Color(0x66ffbf00), Color(0x99ffbf00), Color(0xccffbf00), Color(0xFFffbf00)];
      case "orange": return [Color(0x66ff5f00), Color(0x99ff5f00), Color(0xccff5f00), Color(0xFFff5f00)];
      default: return [Color(0x666CCBCA), Color(0x996CCBCA), Color(0xcc6CCBCA), Color(0xFF6CCBCA)];
    }
  }

  TextField buildTextField(TextEditingController controller, String theme, String name, IconData icon){
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: Colors.black87
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: 14),
        prefixIcon: Icon(
          icon,
          color: returnColorByTheme(theme)
        ),
      hintText: 'Email',
      hintStyle: TextStyle(
        color: Colors.black38
        )
      ),
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
}
