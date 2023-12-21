

import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class DirectoryModel{

  final List<TaskModel> tasks;

  DirectoryModel({
    required this.tasks,
  });

  toJson(){
    return{"Tasks": tasks};
  }

  factory DirectoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return DirectoryModel(
        tasks: data?["Tasks"]
    );
  }
}
