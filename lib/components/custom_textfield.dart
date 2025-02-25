import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/providers/taskify_provider.dart';
import 'package:todo_app/components/text_widget.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.textEditingController,
    this.label,
    this.obscureText = false,
    required this.validate,
    this.fillColor,
    this.prefixIcon,
    this.hintText,
    this.contentPadding,
    this.borderRadius,
    this.labelColor,
    this.textStyleColor,
    this.maxLines,
  });

  final TextEditingController textEditingController;
  final String? label;
  final String? hintText;
  final Color? fillColor;
  final Color? textStyleColor;
  final double? borderRadius;
  final Icon? prefixIcon;
  final Color? labelColor;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final bool obscureText;
  final String? Function(String?) validate;

  @override
  Widget build(BuildContext context) {
    bool hideText = obscureText;
    return Consumer(
      builder: (context, ref, child) => TextFormField(
        controller: textEditingController,
        validator: (value) => validate(value),
        obscureText: hideText,
        style: GoogleFonts.roboto(
          color: textStyleColor ?? AppColors.darkGrey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          contentPadding: contentPadding,
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: GoogleFonts.roboto(
            color: AppColors.darkGrey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: obscureText
              ? IconButton(
                  onPressed: () {
                    ref.read(obsecuretextProvider.notifier).state =
                        !(ref.read(obsecuretextProvider.notifier).state);
                    hideText = !hideText;
                  },
                  icon: Icon(ref.watch(obsecuretextProvider)
                      ? Icons.lock_rounded
                      : Icons.lock_open_rounded))
              : null,
          label: label != null
              ? TextWidget(
                  title: label!,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontColor: labelColor ?? AppColors.greyShade1,
                  textAlign: TextAlign.start,
                )
              : null,
          fillColor: fillColor ?? AppColors.greyShade2,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 20),
            borderSide: BorderSide(
                color: const Color.fromARGB(22, 158, 158, 158), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 20),
            borderSide: BorderSide(color: AppColors.purpleShade2, width: 2),
          ),
        ),
      ),
    );
  }
}
