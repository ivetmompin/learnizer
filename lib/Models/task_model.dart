

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

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      name: map['Name'] ?? '', // Provide a default value if 'id' is null
      description: map['Description'] ?? '',
      deadline: map['Deadline'] ?? '',
      attachments: map['Attachments'] ?? '',
    );
  }
}
