import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/task_item.dart';
import 'package:todo_app/providers/pending_task_provider.dart';

class CompletedTaskNotifier extends StateNotifier<List<TaskItem>> {
  CompletedTaskNotifier({
    required this.ref,
  }) : super([]);

  final Ref ref;

  void addCheckedItem(TaskItem item) {
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

  void removeAllItems() {
    state = [];
  }

  void deleteItem({required String id}) {
    state = state.where((item) => item.id != id).toList();
  }

  void removeItem() {
    // now add to todos list
    state = state.where((item) {
      if (item.isDone == false) {
        ref.read(pendingTaskProvider.notifier).addNewItem(item);
        return false;
      }
      return true;
    }).toList();
  }

  TaskItem getItem(int index) {
    return state[index];
  }
}

final CompletedTaskProvider =
    StateNotifierProvider<CompletedTaskNotifier, List<TaskItem>>(
        (reff) => CompletedTaskNotifier(ref: reff));
