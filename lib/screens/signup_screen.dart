import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/auth_result.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/utils/show_custom_dialog_box.dart';
import 'package:todo_app/components/auth_provider_widget.dart';
import 'package:todo_app/components/custom_button.dart';
import 'package:todo_app/components/custom_textfield.dart';
import 'package:todo_app/components/text_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _signgUp() async {
    if (_formKey.currentState!.validate()) {
      AuthResult authResult = await AuthService().signUpWithEmailPassword(
          email: _emailController.text, password: _passwordController.text);
      if (authResult.user == null) {
        showCustomDialogBox(
          context: context,
          title: "Error",
          content: authResult.errorMessage,
          showMessage: true,
        );
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    "assets/images/tick_logo.jpg",
                    width: size.width / 2.5,
                  ),
                  TextWidget(
                      title: "Lets get started!",
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                  CustomTextfield(
                    textEditingController: _emailController,
                    label: "Enter email",
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Please enter paswword";
                      }
                      return null;
                    },
                  ),
                  CustomTextfield(
                    textEditingController: _passwordController,
                    label: "Enter password",
                    obscureText: true,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Please enter password";
                      }
                      if (value.length < 6) {
                        return "Please enter password at least 6 digit";
                      }
                      return null;
                    },
                  ),
                  CustomButton(
                    childWidget: TextWidget(
                        title: "Sign Up",
                        fontSize: 16,
                        fontColor: AppColors.white,
                        fontWeight: FontWeight.w900),
                    onPressed: () => _signgUp(),
                  ),
                  TextWidget(
                    title: "Or sign up with",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontColor: AppColors.greyShade1,
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      AuthProviderWidget(
                        path: "assets/icons/facebook_icon.png",
                        backgroundColor: AppColors.facebookBlue,
                        onTap: () {
                          showCustomDialogBox(
                              context: context,
                              showMessage: true,
                              content:
                                  "This auth is not available yet! Please try with google.");
                        },
                      ),
                      AuthProviderWidget(
                        path: "assets/icons/google_icon.png",
                        backgroundColor: AppColors.red,
                        onTap: () async {
                          await AuthService().signInWithGoogle();
                          Navigator.of(context).pop();
                        },
                      ),
                      AuthProviderWidget(
                        path: "assets/icons/apple_icon.png",
                        backgroundColor: AppColors.black,
                        onTap: () {
                          showCustomDialogBox(
                              context: context,
                              showMessage: true,
                              content:
                                  "This auth is not available yet! Please try with google.");
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    )),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greyShade1,
                        ), // Inherit default text style

                        children: <TextSpan>[
                          TextSpan(
                            text: "Already have an account? ",
                          ),
                          TextSpan(
                            text: "Log in",
                            style: TextStyle(
                              color: AppColors.purpleShade1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
