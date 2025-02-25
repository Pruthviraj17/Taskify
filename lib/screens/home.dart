import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/task_item.dart';
import 'package:todo_app/providers/completed_tasks_provider.dart';
import 'package:todo_app/providers/taskify_provider.dart';
import 'package:todo_app/providers/pending_task_provider.dart';
import 'package:todo_app/screens/completed_task_screen.dart';
import 'package:todo_app/screens/pending_task_screen.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/firestore_service.dart';
import 'package:todo_app/utils/open_task_modal.dart';
import 'package:todo_app/utils/show_custom_dialog_box.dart';
import 'package:todo_app/utils/split_task.dart';
import 'package:todo_app/widgets/add_task_item.dart';
import 'package:todo_app/components/custom_textfield.dart';
import 'package:todo_app/widgets/navigation_bar_widget.dart';
import 'package:todo_app/widgets/notasks_icon.dart';
import 'package:todo_app/widgets/task_item_details.dart';
import 'package:todo_app/components/text_widget.dart';
import 'package:todo_app/widgets/task_list_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Future<void> fetchTasks() async {
    // await FirestoreService().addDummyTask();
    List<TaskItem> taskItems = await FirestoreService().getTasks();
    splitTask(taskItems: taskItems, ref: ref);
  }

  void removeItems() {
    ref.read(CompletedTaskProvider.notifier).removeAllItems();
  }

  void deleteAllCheckedList() {
    showCustomDialogBox(
      context: context,
      title: "Remove All",
      content: "Do you really want to delete all the checked list?",
      onPressed: () => removeItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasks = ref.watch(pendingTaskProvider);
    final pendingTasksLength = pendingTasks.length;
    final completedTasks = ref.watch(CompletedTaskProvider);
    final completedTasksLength = completedTasks.length;

    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: ref.watch(currentIndexProvider) == 0
          ? PendingTaskScreen(
              ref: ref,
              todoItems: pendingTasks,
              todoItemsLength: pendingTasksLength,
              searchController: _searchController)
          : CompletedTaskScreen(
              completedTasks: completedTasks,
              completedTasksLength: completedTasksLength,
              ref: ref,
            ),
      // }),
      bottomNavigationBar: NavigationBarWidget(
        ref: ref,
        onTap: () => openTodoItemModal(
            widget: AddTaskItem(ref: ref), context: context, ref: ref),
      ),
    );
  }
}
