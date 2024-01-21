

import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class DirectoryModel{
  final String name;
  final String image;
  final List<TaskModel> tasks;

  DirectoryModel({
    required this.name,
    required this.image,
    required this.tasks,
  });

  toJson(){
    return{"Name":name,"Image":image,"Tasks":tasks.map((task) => task.toJson()).toList()};
  }

  factory DirectoryModel.fromMap(Map<String, dynamic> map) {
    return DirectoryModel(
      name: map["Name"] ?? '',
      image: map["Image"] ?? '',
      tasks: (map['Tasks'] as List<dynamic>?)?.map((task) => TaskModel.fromMap(task)).toList() ?? [],
    );
  }
}
