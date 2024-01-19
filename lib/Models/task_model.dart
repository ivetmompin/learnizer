

import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel{

  final String name;
  final String description;
  final DateTime deadline;
  final List<String> attachments;

  TaskModel({
    required this.name,
    required this.description,
    required this.deadline,
    required this.attachments,
  });

  toJson(){
    return{"Name": name, "Description": description, "Deadline": deadline, "Attachments": attachments};
  }

  factory TaskModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {

      return TaskModel(
          name: data["Name"],
          description: data["Description"],
          deadline: data["Deadline"],
          attachments: data["Attachments"],
      );
    } else {
      DateTime dateTime = DateTime.now();
      // Handle the case where data is null (optional)
      return TaskModel(name:'',description:'',deadline: dateTime,attachments: []);
    }
  }
}
