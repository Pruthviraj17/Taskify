import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/components/text_widget.dart';
import 'package:todo_app/constants/colors.dart';

Future<DateTime?> customDatePicker(BuildContext context) async {
  final now = DateTime.now();

  if (Platform.isIOS) {
    DateTime selectedDate = now;

    return await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: AppColors.textColor, // Change text color to purple
                      fontSize: 18, // Adjust font size if needed
                      fontWeight: FontWeight.w500, // Make text slightly bold
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: now,
                  minimumDate: now, // Prevents picking past dates
                  maximumDate: DateTime(now.year + 100),
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
            ),
            CupertinoButton(
              child: TextWidget(
                title: "Select",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontColor: AppColors.purpleShade2,
              ),
              onPressed: () => Navigator.of(context).pop(selectedDate),
            ),
          ],
        ),
      ),
    );
  } else {
    // Android Date Picker (Material)
    return await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 100),
      confirmText: 'Select',
      cancelText: 'Cancel',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.purpleShade1,
            colorScheme: ColorScheme.light(
              primary: AppColors
                  .purpleShade1, // Header background & selected date color
              onPrimary: AppColors.white, // Text color in header
              onSurface: AppColors.purpleShade1, // Text color for dates
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
