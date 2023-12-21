

import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel{

  final String name;
  final String description;
  final List<String> attachments;

  TaskModel({
    required this.name,
    required this.description,
    required this.attachments,
  });

  toJson(){
    return{"Name": name, "Description": description, "Attachments": attachments};
  }

  factory TaskModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return TaskModel(
        name: data?["Name"],
        description: data?["Description"],
        attachments: data?["Attachments"]
    );
  }
}
