import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/utils/ding_notification.dart';
import 'package:todo_app/models/task_item.dart';
import 'package:todo_app/providers/completed_tasks_provider.dart';

class PendingTaskNotifier extends StateNotifier<List<TaskItem>> {
  PendingTaskNotifier({
    required this.ref,
  }) : super([]);

  final Ref ref;

  void addAll(List<TaskItem> taskItems) async {
    state = taskItems.where(
      (task) {
        if (!task.isDone) {
          return true;
        }
        return false;
      },
    ).toList();
    sortAllTasks();
  }

  void addNewItem(TaskItem item) async {
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

  void removeItem() async {
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

    sortAllTasks();
  }

  void deleteItem({required String id}) {
    state = state.where((item) => item.id != id).toList();
  }

  TaskItem getItem(int index) {
    return state[index];
  }

  void resetData() {
    state = [];
  }
}

final pendingTaskProvider =
    StateNotifierProvider<PendingTaskNotifier, List<TaskItem>>((reff) {
  return PendingTaskNotifier(ref: reff);
});
