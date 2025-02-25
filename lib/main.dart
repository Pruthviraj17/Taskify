import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/signup_screen.dart';
import 'package:todo_app/screens/welcome_screen.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: lightTheme,
      // darkTheme: darkTheme,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.purpleShade1),
              );
            }
            if (snapshot.data != null) {
              // AuthService().signOut();
              print("Login Succesfully");
              return const HomeScreen();
            }

            return const WelcomeScreen();
          }),
    );
  }
}
