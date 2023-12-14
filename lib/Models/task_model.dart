

import 'package:cloud_firestore/cloud_firestore.dart';

class DirectoryModel{

  final List<TaskModel> tasks;

  DirectoryModel({
    required this.name,
    required this.owner,
    required this.description,
    required this.image,
  });

  toJson(){
    return{"Name": name, "Owner": owner, "Description": description, "Image": image};
  }

  factory DirectoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return DirectoryModel(
        name: data?["Name"],
        owner: data?["Owner"],
        description: data?["Description"],
        image: data?["Image"]
    );
  }
}
