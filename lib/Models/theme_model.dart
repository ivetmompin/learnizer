

import 'package:cloud_firestore/cloud_firestore.dart';
import 'directory_model.dart';

class ThemeModel{
  final String email;
  final String theme;

  ThemeModel({
    required this.email,
    required this.theme,
  });

  toJson(){
    return{"Email": email, "Theme": theme};
  }

  factory ThemeModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return ThemeModel(
        email: data?["Email"],
        theme: data?["Theme"],
    );
  }
}
