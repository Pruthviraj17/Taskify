import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/components/custom_textfield.dart';
import 'package:todo_app/components/text_widget.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/task_item.dart';
import 'package:todo_app/providers/completed_tasks_provider.dart';
import 'package:todo_app/providers/pending_task_provider.dart';
import 'package:todo_app/providers/taskify_provider.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/firestore_service.dart';
import 'package:todo_app/utils/open_task_modal.dart';
import 'package:todo_app/utils/show_custom_dialog_box.dart';
import 'package:todo_app/widgets/add_task_item.dart';
import 'package:todo_app/widgets/notasks_icon.dart';
import 'package:todo_app/widgets/task_item_details.dart';
import 'package:todo_app/widgets/show_snackbar.dart';
import 'package:todo_app/widgets/task_list_widget.dart';

class PendingTaskScreen extends ConsumerStatefulWidget {
  const PendingTaskScreen(
      {super.key,
      required this.ref,
      required this.todoItems,
      required this.todoItemsLength,
      required this.searchController});
  final WidgetRef ref;
  final List<TaskItem> todoItems;
  final int todoItemsLength;
  final TextEditingController searchController;

  @override
  ConsumerState<PendingTaskScreen> createState() => _PendingTaskScreenState();
}

class _PendingTaskScreenState extends ConsumerState<PendingTaskScreen> {
  late User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  bool isToday(DateTime dueDate) {
    DateTime now = DateTime.now();
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }

  Future<void> _signOut() async {
    showCustomDialogBox(
      context: context,
      title: "Logout ",
      content: "Do you really want to log out?",
      onPressed: () async => {
        await AuthService().signOut(),
        ref.read(pendingTaskProvider.notifier).resetData(),
        ref.read(CompletedTaskProvider.notifier).resetData(),
        ref.read(currentIndexProvider.notifier).state = 0,
      },
    );
  }

  Future<void> _deletedItem(
      {required TaskItem taskItem,
      required int index,
      required int todoItemsLength}) async {
    await FirestoreService().deleteTask(taskItem.id);
    ref.read(pendingTaskProvider.notifier).deleteItem(id: taskItem.id);
    showSnackBar(
      cnt: "${taskItem.title}  deleted.",
      context: context,
    );
  }

  Future<void> _editItem(TaskItem taskItem) async {
    ref.read(selectedPriorityProvider.notifier).state = taskItem.priority;
    ref.read(pickedDueDateProvider.notifier).state = taskItem.dueDate;
    openTodoItemModal(
        widget: AddTaskItem(
          ref: ref,
          taskItem: taskItem,
        ),
        context: context,
        ref: ref);
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
                  children: [
                    // widget
                    user!.photoURL != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(user!.photoURL!),
                          )
                        : Image.asset(
                            "assets/icons/menu.png",
                            height: 25,
                            color: AppColors.white,
                          ),
                    // serach
                    Flexible(
                      child: CustomTextfield(
                        textEditingController: widget.searchController,
                        fillColor: AppColors.white,
                        textStyleColor: AppColors.purpleShade1,
                        hintText: "Search",
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.darkGrey,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        borderRadius: 30,
                        validate: (value) {
                          return null;
                        },
                      ),
                    ),
                    // logout
                    IconButton(
                        onPressed: () => _signOut(),
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
                      title:
                          "Today, ${DateFormat('d MMMM').format(DateTime.now())}",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontColor: AppColors.homeBackground,
                      textAlign: TextAlign.start,
                    ),
                    TextWidget(
                      title: user!.displayName != null
                          ? "Welcome! ${user!.displayName}"
                          : "My Tasks",
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
        if (widget.todoItems.isEmpty)
          Expanded(
              child: NoTasksIcon(
            message: "Add some Tasks!",
          )),
        if (widget.todoItems.isNotEmpty)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.todoItemsLength + 1,
                itemBuilder: (context, index) {
                  if (index == 0 && widget.todoItems.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: Row(
                        children: [
                          TextWidget(
                              title: "Pending Tasks",
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ],
                      ),
                    );
                  }
                  if (widget.todoItems.isEmpty) {
                    return SizedBox();
                  }
                  final todoItem = widget.todoItems[index - 1];

                  return GestureDetector(
                    onTap: () => openTodoItemModal(
                      widget: TaskItemDetails(
                        itemIndex: index,
                        todoItem: todoItem,
                      ),
                      context: context,
                      ref: widget.ref,
                    ),
                    child: Slidable(
                      key: Key(index.toString()),
                      endActionPane: ActionPane(
                        motion: StretchMotion(),
                        children: [
                          SlidableAction(
                            icon: Icons.edit,
                            autoClose: true,
                            foregroundColor: AppColors.white,
                            onPressed: (context) {
                              _editItem(todoItem);
                            },
                            backgroundColor: AppColors.purpleShade1,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          SlidableAction(
                            icon: Icons.delete,
                            autoClose: true,
                            onPressed: (context) {
                              _deletedItem(
                                  taskItem: todoItem,
                                  index: index,
                                  todoItemsLength: widget.todoItemsLength);
                            },
                            backgroundColor: AppColors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                      child: TaskListWidget(
                        isPending: true,
                        todoItem: todoItem,
                        index: index,
                        todoItemsLength: widget.todoItemsLength,
                        ref: widget.ref,
                        formattedDate:
                            DateFormat('d MMMM').format(todoItem.dueDate),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
