import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/components/text_widget.dart';

void showCustomDialogBox({
  required BuildContext context,
  String? title,
  String? content,
  bool showMessage = false,
  void Function()? onPressed,
}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: title != null
              ? TextWidget(
                  title: title,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )
              : null,
          content: content != null
              ? TextWidget(
                  title: content,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )
              : null,
          actions: [
            if (!showMessage)
              CupertinoDialogAction(
                child: TextWidget(
                  title: "Cancel",
                  fontSize: 14,
                  fontColor: AppColors.green,
                  fontWeight: FontWeight.normal,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
              child: TextWidget(
                title: "Ok",
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontColor: AppColors.red,
              ),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: title != null
              ? TextWidget(
                  title: title,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )
              : null,
          content: content != null
              ? TextWidget(
                  title: content,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )
              : null,
          actions: [
            if (!showMessage)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: TextWidget(
                  title: "Cancel",
                  fontSize: 14,
                  fontColor: AppColors.green,
                  fontWeight: FontWeight.normal,
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
              child: TextWidget(
                title: "Ok",
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontColor: AppColors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
