
import 'package:intl/intl.dart';

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
    String deadlineAux = map['Deadline'];
    DateTime deadline;

    try {
      // Try parsing the date with the expected format "dd/MM/yyyy"
      DateFormat format = DateFormat("dd/MM/yyyy");
      deadline = format.parse(deadlineAux);
    } catch (e) {
      print('Error parsing deadline: $e');
      // Handle parsing error, or use a default date if needed
      deadline = DateTime.now();
    }
    return TaskModel(
      name: map["Name"] ?? '',
      description: map["Description"] ?? '',
      deadline: deadline,
      attachments: (map['Attachments'] as List<dynamic>?)?.map((attachment) => attachment.toString()).toList() ?? [],
    );
  }

}
