import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.childWidget,
    this.color = const Color(0xff2F80ED),
    required this.onPressed,
    this.isButtonEnabled = true,
  });
  final Widget childWidget;
  final void Function() onPressed;
  final Color color;
  final bool isButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: isButtonEnabled ? onPressed : () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purpleShade1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: childWidget,
        ),
      ),
    );
  }
}
