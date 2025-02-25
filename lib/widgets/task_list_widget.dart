import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/components/text_widget.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/services/firestore_service.dart';
import 'package:todo_app/utils/getcolors_priority.dart';
import 'package:todo_app/models/task_item.dart';
import 'package:todo_app/providers/completed_tasks_provider.dart';
import 'package:todo_app/providers/pending_task_provider.dart';
import 'package:todo_app/widgets/show_snackbar.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget(
      {super.key,
      required this.todoItem,
      required this.index,
      required this.todoItemsLength,
      required this.ref,
      required this.formattedDate,
      required this.isPending});

  final TaskItem todoItem;
  final int index;
  final bool isPending;
  final int todoItemsLength;
  final WidgetRef ref;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
        elevation: 0.05,
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 15),
          child: Row(
            children: [
              Checkbox(
                checkColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  // Customize the shape
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                side: BorderSide(
                  // Border styling
                  color: AppColors.purpleShade1, // Purple border color
                  width: 2, // Border width
                ),
                activeColor: AppColors.purpleShade1,
                value: todoItem.isDone,
                onChanged: (value) {
                  // todoItem.isDone = value!;
                  // if (index < todoItemsLength) {
                  if (isPending) {
                    ref
                        .read(pendingTaskProvider.notifier)
                        .isChecked(todoItem, value!);
                    showSnackBar(
                        cnt: "${todoItem.title} marked as done.",
                        context: context);
                  } else {
                    ref
                        .read(CompletedTaskProvider.notifier)
                        .isChecked(todoItem, value!);
                    showSnackBar(
                        cnt: "${todoItem.title} marked as pending.",
                        context: context);
                  }
                  FirestoreService().updateTaskStatus(todoItem.id, value);
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.4,
                    child: TextWidget(
                      title: todoItem.title,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textOverflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  TextWidget(
                    title: formattedDate,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.greyShade1,
                  ),
                ],
              ),
              Spacer(),
              Container(
                width: 70,
                height: 25,
                decoration: BoxDecoration(
                  color: getColorPriority(todoItem.priority),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: TextWidget(
                    title: todoItem.priority,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    fontColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
