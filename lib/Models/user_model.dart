

import 'package:cloud_firestore/cloud_firestore.dart';
import 'directory_model.dart';

class UserModel{
  final String email;
  final List<DirectoryModel> directories;
  final String profileImage;
  final String appTheme;

  UserModel({
    required this.email,
    required this.directories,
    required this.profileImage,
    required this.appTheme
  });

  toJson(){
    return{"Email": email, "Directories": directories, "ProfileImage": profileImage, "AppTheme": appTheme};
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return UserModel(
        email: data?["Email"],
        directories: data?["Directories"],
        profileImage: data?["ProfileImage"],
        appTheme: data?["AppTheme"]
    );
  }
}
