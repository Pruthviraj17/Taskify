import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/task_item.dart';
import 'package:todo_app/providers/completed_tasks_provider.dart';
import 'package:todo_app/providers/pending_task_provider.dart';

void showSnackBar({
  required String cnt,
  required BuildContext context,
  bool isDeleted = false,
  WidgetRef? ref = null,
  int? index = null,
  int? todoItemsLength = null,
  TaskItem? item = null,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.purpleShade2,
      content: Text(cnt),
      action: !isDeleted
          ? null
          : SnackBarAction(
              label: "Undo",
              onPressed: () {
                // restore again
                if (index! < todoItemsLength!) {
                  ref!.read(pendingTaskProvider.notifier).addNewItem(item!);
                  showSnackBar(
                      cnt: "Task restored successfully", context: context);
                } else {
                  ref!
                      .read(CompletedTaskProvider.notifier)
                      .addCheckedItem(item!);
                  showSnackBar(
                      cnt: "Task restored successfully", context: context);
                }
              },
            ),
    ),
  );
}
