

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
    return{"Name":name,"Image":image,"Tasks":tasks};
  }

  factory DirectoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {
      // Assuming "Tasks" is a List<dynamic> in Firestore
      final List<dynamic>? tasksData = data["Tasks"];

      // Use map() to convert each item in the list to a TaskModel
      final List<TaskModel> tasks = tasksData?.map((taskData) {
        return TaskModel.fromSnapshot(taskData);
      }).toList() ?? [];

      return DirectoryModel(
        name: data["Name"],
        image: data["Image"],
        tasks: tasks,
      );
    } else {
      // Handle the case where data is null (optional)
      return DirectoryModel(name: '',image: '',tasks: []);
    }
  }

  factory DirectoryModel.fromMap(Map<String, dynamic> map) {
    return DirectoryModel(
      name: map["Name"] ?? '',
      image: map["Image"] ?? '',
      tasks: map['Tasks'] ?? '',
    );
  }
}
