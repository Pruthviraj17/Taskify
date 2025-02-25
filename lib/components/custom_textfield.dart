import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    this.height,
    this.hintText,
  });

  final TextEditingController textEditingController;
  final String? label;
  final String? hintText;
  final Color? fillColor;
  final Icon? prefixIcon;
  final double? height;
  final bool obscureText;
  final String? Function(String?) validate;

  @override
  Widget build(BuildContext context) {
    bool hideText = obscureText;
    return Consumer(
      builder: (context, ref, child) => SizedBox(
        height: height,
        child: TextFormField(
          controller: textEditingController,
          validator: (value) => validate(value),
          obscureText: hideText,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            hintText: hintText,
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
            label: TextWidget(
              title: label ?? "",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontColor: AppColors.greyShade1,
              textAlign: TextAlign.start,
            ),
            fillColor: fillColor ?? AppColors.greyShade2,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: const Color.fromARGB(22, 158, 158, 158), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.purpleShade2, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
