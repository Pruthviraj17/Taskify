import 'package:cloud_firestore/cloud_firestore.dart';

class TaskItem {
  final String id;
  String? userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority;
  bool isDone;

  TaskItem({
    required this.id,
    this.userId,
    required this.dueDate,
    required this.priority,
    required this.title,
    required this.description,
    required this.isDone,
  });
  // id = const Uuid().v4();

  // Convert TaskItem to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate), // Firestore timestamp
      'priority': priority,
      'isDone': isDone,
    };
  }

  // Create TaskItem from Firestore snapshot
  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      priority: json['priority'],
      isDone: json['isDone'],
    );
  }
}
