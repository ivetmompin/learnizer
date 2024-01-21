import 'package:cloud_firestore/cloud_firestore.dart';
import 'directory_model.dart';

class UserModel{
  final String email;
  final String name;
  final List<DirectoryModel> directories;
  final String profileImage;
  final String theme;

  UserModel({
    required this.email,
    required this.name,
    required this.directories,
    required this.profileImage,
    required this.theme,
  });

  toJson(){
    return{"Email": email, "Name": name, "Directories": directories.map((directory) => directory.toJson()).toList(), "ProfileImage": profileImage, "Theme": theme};
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {
      // Assuming "Tasks" is a List<dynamic> in Firestore
      final List<dynamic>? directoriesData = data["Directories"];

      // Use map() to convert each item in the list to a TaskModel
      final List<DirectoryModel> directories = directoriesData?.map((directoriesData) {
        return DirectoryModel.fromMap(directoriesData);
      }).toList() ?? [];

      return UserModel(
          email: data["Email"],
          name: data["Name"],
          directories: directories,
          profileImage: data["ProfileImage"],
          theme: data["Theme"]
      );
    } else {
      // Handle the case where data is null (optional)
      return UserModel(email:'',name:'',directories: [],profileImage: '',theme:'');
    }
  }
}
