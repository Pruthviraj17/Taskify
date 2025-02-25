import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/task_item.dart';
import 'package:todo_app/providers/completed_tasks_provider.dart';
import 'package:todo_app/providers/pending_task_provider.dart';

void splitTask({required List<TaskItem> taskItems, required WidgetRef ref}) {
  // logic to split task on checked or unchecked
  ref.read(pendingTaskProvider.notifier).addAll(taskItems);
  ref.read(CompletedTaskProvider.notifier).addAll(taskItems);
}
