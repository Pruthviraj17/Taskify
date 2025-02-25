import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/services/firestore_service.dart';
import 'package:todo_app/utils/ding_notification.dart';
import 'package:todo_app/models/task_item.dart';
import 'package:todo_app/providers/completed_tasks_provider.dart';
import 'package:uuid/uuid.dart';

class PendingTaskNotifier extends StateNotifier<List<TaskItem>> {
  PendingTaskNotifier({
    required this.ref,
  }) : super([
          TaskItem(
              isDone: false,
              id: Uuid().v4(),
              title: "Morning Run",
              description: "Go for a 5 km run at 6 AM",
              dueDate: DateTime.now(),
              priority: "low"),
          TaskItem(
              isDone: false,
              id: Uuid().v4(),
              title: "Grocery Shopping",
              description: "Buy vegetables, fruits, and dairy products",
              dueDate: DateTime.now().add(Duration(days: 7)),
              priority: "high"),
          TaskItem(
              isDone: false,
              id: Uuid().v4(),
              title: "Doctor Appointment",
              description: "Visit Dr. Sharma for a routine check-up",
              dueDate: DateTime.now().add(Duration(days: 1)),
              priority: "low"),
          TaskItem(
              isDone: false,
              id: Uuid().v4(),
              title: "Project Meeting",
              description: "Discuss project updates with the team",
              dueDate: DateTime.now(),
              priority: "high"),
          TaskItem(
              isDone: false,
              id: Uuid().v4(),
              title: "Book Reading",
              description: "Read 50 pages of a self-improvement book",
              dueDate: DateTime.now().add(Duration(days: 9)),
              priority: "medium"),
        ]);

  final Ref ref;

  void addNewItem(TaskItem item) async {
    await FirestoreService().addTask(item);
    state = [...state, item];
    sortAllTasks();
  }

  void sortAllTasks() {
    state.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  Future<void> isChecked(TaskItem item, bool value,
      {bool onDissmised = false}) async {
    state = state.where((itm) {
      if (itm.id == item.id) {
        itm.isDone = value;
      }
      return true;
    }).toList();

    if (onDissmised) {
      removeItem();
    }

    return removeItem();
  }

  void removeItem() {
    // now add to completed list
    state = state.where((item) {
      if (item.isDone == true) {
        playDingNotificationSound();
        ref.read(CompletedTaskProvider.notifier).addCheckedItem(item);
        return false;
      }
      return true;
    }).toList();
  }

  void updateItem(TaskItem taskItem) {
    // now add to completed list
    state = state.map((item) {
      if (item.id == taskItem.id) {
        return taskItem;
      }
      return item;
    }).toList();
  }

  void deleteItem({required String id}) {
    state = state.where((item) => item.id != id).toList();
  }

  TaskItem getItem(int index) {
    return state[index];
  }
}

final pendingTaskProvider =
    StateNotifierProvider<PendingTaskNotifier, List<TaskItem>>((reff) {
  return PendingTaskNotifier(ref: reff);
});
