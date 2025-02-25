// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:todo_app/constants/colors.dart';

class TextWidget extends StatelessWidget {
  TextWidget({
    Key? key,
    required this.title,
    required this.fontSize,
    required this.fontWeight,
    this.lineThrough = false,
    this.fontColor,
    this.textAlign,
    this.textOverflow,
    this.softWrap,
    this.maxLines,
  }) : super(key: key);

  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final bool lineThrough;
  final Color? fontColor;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final bool? softWrap;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        color: fontColor ?? AppColors.textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      ),
      overflow: textOverflow,
      softWrap: softWrap,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}
