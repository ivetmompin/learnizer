
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TaskModel{

  final String name;
  final String description;
  final DateTime deadline;
  late final bool isDone;
  final List<String> attachments;

  TaskModel({
    required this.name,
    required this.description,
    required this.deadline,
    required this.isDone,
    required this.attachments,
  });

  toJson(){
    return{"Name": name, "Description": description, "Deadline": deadline, "IsDone": isDone,"Attachments": attachments};
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    Timestamp timestamp = map['Deadline'];
    DateTime deadline = timestamp.toDate(); // Convert Timestamp to DateTime
    return TaskModel(
      name: map["Name"] ?? '',
      description: map["Description"] ?? '',
      deadline: deadline,
      isDone: map["IsDone"] ?? false,
      attachments: (map['Attachments'] as List<dynamic>?)?.map((attachment) => attachment.toString()).toList() ?? [],
    );
  }

}
