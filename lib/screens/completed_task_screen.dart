import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/components/custom_textfield.dart';
import 'package:todo_app/components/text_widget.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/task_item.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/utils/open_task_modal.dart';
import 'package:todo_app/utils/show_custom_dialog_box.dart';
import 'package:todo_app/widgets/notasks_icon.dart';
import 'package:todo_app/widgets/show_item_details.dart';
import 'package:todo_app/widgets/task_list_widget.dart';

class CompletedTaskScreen extends StatelessWidget {
  const CompletedTaskScreen(
      {super.key,
      required this.ref,
      required this.completedTasks,
      required this.completedTasksLength});

  final WidgetRef ref;
  final List<TaskItem> completedTasks;
  final int completedTasksLength;

  Future<void> _signOut(BuildContext context) async {
    showCustomDialogBox(
      context: context,
      title: "Logout ",
      content: "Do you really want to log out?",
      onPressed: () => AuthService().signOut(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              AppColors.purpleShade1,
              AppColors.purpleShade2,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // widget
                    Image.asset(
                      "assets/icons/completed_icon.png",
                      height: 25,
                      color: AppColors.white,
                    ),

                    IconButton(
                        onPressed: () => _signOut(context),
                        icon: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.greyShade3,
                          child: Icon(
                            Icons.logout_rounded,
                            color: AppColors.white,
                          ),
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //texts
                    TextWidget(
                      title: DateFormat('d MMMM').format(DateTime.now()),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontColor: AppColors.homeBackground,
                      textAlign: TextAlign.start,
                    ),
                    TextWidget(
                      title: "My Completed Task",
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontColor: AppColors.white,
                      textAlign: TextAlign.start,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        if (completedTasks.isEmpty)
          Expanded(
              child: NoTasksIcon(
            message: "No tasks completed yet!",
          )),
        if (completedTasks.isNotEmpty)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: completedTasksLength + 1,
                itemBuilder: (context, index) {
                  if (index == 0 && completedTasks.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: Row(
                        children: [
                          TextWidget(
                              title: "Completed Tasks",
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ],
                      ),
                    );
                  }
                  if (completedTasks.isEmpty) {
                    return SizedBox();
                  }
                  final todoItem = completedTasks[index - 1];

                  return GestureDetector(
                    onTap: () => openTodoItemModal(
                      widget: ShowItemDetails(
                        itemIndex: index,
                        todoItem: todoItem,
                      ),
                      context: context,
                      ref: ref,
                    ),
                    child: TaskListWidget(
                        todoItem: todoItem,
                        isPending: false,
                        index: index,
                        todoItemsLength: completedTasksLength,
                        ref: ref,
                        formattedDate:
                            DateFormat('d MMMM').format(todoItem.dueDate)),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
