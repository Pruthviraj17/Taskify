import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';

class AuthProviderWidget extends StatelessWidget {
  const AuthProviderWidget(
      {super.key,
      required this.backgroundColor,
      required this.path,
      this.onTap});
  final Color backgroundColor;
  final String path;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: CircleAvatar(
        radius: 30,
        backgroundColor: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset(
            path,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
