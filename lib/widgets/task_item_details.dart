import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/task_item.dart';
import 'package:todo_app/components/text_widget.dart';

class TaskItemDetails extends StatelessWidget {
  const TaskItemDetails({
    super.key,
    required this.itemIndex,
    required this.todoItem,
  });
  final int itemIndex;
  final TaskItem todoItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              Icons.drag_handle_rounded,
              size: 30,
              color: AppColors.purpleShade1,
            ),
          ),
          const SizedBox(
            height: 31,
          ),
          TextWidget(
            fontColor: AppColors.purpleShade1,
            title: "Title",
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          TextWidget(
            fontColor: AppColors.darkGrey,
            title: todoItem.title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(
            height: 21,
          ),
          TextWidget(
              fontColor: AppColors.purpleShade1,
              title: "Descrpiton",
              fontSize: 20,
              fontWeight: FontWeight.w600),
          TextWidget(
            fontColor: AppColors.darkGrey,
            title: todoItem.description,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(
            height: 21,
          ),
          TextWidget(
              fontColor: AppColors.purpleShade1,
              title: "Priority",
              fontSize: 18,
              fontWeight: FontWeight.w600),
          TextWidget(
              fontColor: AppColors.darkGrey,
              title: todoItem.priority,
              fontSize: 14,
              fontWeight: FontWeight.w500),
          const SizedBox(
            height: 21,
          ),
          TextWidget(
              fontColor: AppColors.purpleShade1,
              title: "Due Date",
              fontSize: 16,
              fontWeight: FontWeight.w600),
          TextWidget(
              fontColor: AppColors.darkGrey,
              title: DateFormat('d MMMM').format(todoItem.dueDate),
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ],
      ),
    );
  }
}
