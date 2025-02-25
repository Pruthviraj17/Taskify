import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/components/text_widget.dart';

import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/providers/taskify_provider.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget(
      {super.key, required this.onTap, required this.ref});
  final void Function() onTap;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    int currentIndex = ref.watch(currentIndexProvider);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 100,
          width: double.infinity,
          color: AppColors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  ref.read(currentIndexProvider.notifier).state = 0;
                },
                icon: Image.asset(
                  "assets/icons/pending_icon.png",
                  color: currentIndex == 0
                      ? AppColors.purpleShade1
                      : AppColors.purpleShade2,
                  height: currentIndex == 0 ? 30 : 25,
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(currentIndexProvider.notifier).state = 1;
                },
                icon: Image.asset(
                  "assets/icons/completed_icon.png",
                  color: currentIndex == 1
                      ? AppColors.purpleShade1
                      : AppColors.purpleShade2,
                  height: currentIndex == 1 ? 30 : 25,
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: -20,
          right: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 5),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.purpleShade1,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.3,
                          blue: 2,
                        ), // Shadow color
                        blurRadius: 8, // Soften the shadow
                        spreadRadius: 2, // Extend the shadow
                        offset: Offset(0, 4), // Vertical shadow movement
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
