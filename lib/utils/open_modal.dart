import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/providers/taskify_provider.dart';

Future<void> openTodoItemModal(
    {required Widget widget,
    required BuildContext context,
    required WidgetRef ref}) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30))),
    backgroundColor: AppColors.appBackground,
    isDismissible: true,
    context: context,
    builder: (context) {
      return widget;
    },
  );
  ref.read(pickedDueDateProvider.notifier).state = DateTime.now();
  ref.read(selectedPriorityProvider.notifier).state = "high";
}
