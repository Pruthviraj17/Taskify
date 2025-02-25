import 'package:flutter/widgets.dart';
import 'package:todo_app/constants/colors.dart';

class NoTasksIcon extends StatelessWidget {
  const NoTasksIcon({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
