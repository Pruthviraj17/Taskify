import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task_item.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get current user ID
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  // Add task to Firestore (linked to the current user)
  Future<void> addTask(TaskItem task) async {
    try {
      if (_userId == null) throw Exception("User not logged in");

      task.userId = _userId!; // Assign userId before storing

      await _db.collection('tasks').doc(task.id).set(task.toJson());
    } catch (e) {
      debugPrint("Error adding task: $e");
    }
  }

  // Fetch tasks for the logged-in user only
  Future<List<TaskItem>> getTasks() async {
    try {
      if (_userId == null) throw Exception("User not logged in");

      final snapshot = await _db
          .collection('tasks')
          .where('userId', isEqualTo: _userId) // Filter by userId
          .get();

      return snapshot.docs.map((doc) => TaskItem.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint("Error fetching tasks: $e");
      return [];
    }
  }

  // Delete task (only if the task belongs to the current user)
  Future<void> deleteTask(String taskId) async {
    try {
      if (_userId == null) throw Exception("User not logged in");

      final doc = await _db.collection('tasks').doc(taskId).get();
      if (doc.exists && doc.data()?['userId'] == _userId) {
        await _db.collection('tasks').doc(taskId).delete();
      } else {
        throw Exception("Unauthorized to delete this task");
      }
    } catch (e) {
      debugPrint("Error deleting task: $e");
    }
  }

  // Update task status (only if the task belongs to the user)
  Future<void> updateTaskStatus(String taskId, bool isDone) async {
    try {
      if (_userId == null) throw Exception("User not logged in");

      final doc = await _db.collection('tasks').doc(taskId).get();
      if (doc.exists && doc.data()?['userId'] == _userId) {
        await _db.collection('tasks').doc(taskId).update({'isDone': isDone});
      } else {
        throw Exception("Unauthorized to update this task");
      }
    } catch (e) {
      debugPrint("Error updating task status: $e");
    }
  }

  // Update task details (only if the task belongs to the user)
  Future<void> updateTaskDetails(TaskItem taskItem) async {
    try {
      if (_userId == null) throw Exception("User not logged in");

      final doc = await _db.collection('tasks').doc(taskItem.id).get();
      if (doc.exists && doc.data()?['userId'] == _userId) {
        await _db
            .collection('tasks')
            .doc(taskItem.id)
            .update(taskItem.toJson());
      } else {
        throw Exception("Unauthorized to update this task");
      }
    } catch (e) {
      debugPrint("Error updating task details: $e");
    }
  }
}
