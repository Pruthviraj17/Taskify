import 'dart:ui';

import 'package:todo_app/constants/colors.dart';

Color getColorPriority(String priority) {
  switch (priority.toLowerCase()) {
    case "low":
      return AppColors.orangeShade1;
    case "medium":
      return AppColors.mediumPriority;
    case "high":
      return AppColors.purpleShade2;
    default:
      return AppColors.orangeShade1;
  }
}
