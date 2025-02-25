import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/task_item.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add task to Firestore
  Future<void> addTask(TaskItem task) async {
    try {
      await _db.collection('tasks').doc(task.id).set(task.toJson());
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  // Fetch all tasks
  Stream<List<TaskItem>> getTasks() {
    return _db.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TaskItem.fromJson(doc.data())).toList();
    });
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    await _db.collection('tasks').doc(taskId).delete();
  }

  // Update task status
  Future<void> updateTaskStatus(String taskId, bool isDone) async {
    await _db.collection('tasks').doc(taskId).update({'isDone': isDone});
  }
}
