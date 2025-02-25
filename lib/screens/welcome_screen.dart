import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/signup_screen.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/components/text_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Widget navigationDot(Color color) {
    return CircleAvatar(
      radius: 4,
      backgroundColor: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // image icon
          Spacer(
            flex: 4,
          ),
          // text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/tick_logo.jpg",
                      width: size.width / 2.5,
                    ),
                  ],
                ),
                TextWidget(
                    title: "Get things done.",
                    fontSize: 24,
                    fontWeight: FontWeight.w900),
                TextWidget(
                  title: "Just a click away from\nplanning your task.",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontColor: AppColors.greyShade1,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 15,
                  children: [
                    navigationDot(AppColors.greyShade1),
                    navigationDot(AppColors.greyShade1),
                    navigationDot(AppColors.purpleShade1),
                  ],
                )
              ],
            ),
          ),
          Spacer(
            flex: 2,
          ),
          // navigator
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignupScreen(),
                )),
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    // color: AppColors.purpleShade1,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.purpleShade1,
                        AppColors.purpleShade2,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 60,
                          weight: 1,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
