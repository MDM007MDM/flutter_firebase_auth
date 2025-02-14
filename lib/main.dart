import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/firebase_options.dart';
import 'package:flutter_firebase_auth/create_account_screen.dart';
import 'package:flutter_firebase_auth/forgot_password_screen.dart';
import 'package:flutter_firebase_auth/home_screen.dart';
import 'package:flutter_firebase_auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginPage(),
        '/create_account': (context) => CreateAccountPage(),
        '/home': (context) => HomePage(),
        '/forgot_password': (context) => ForgotPasswordPage()
      },
    );
  }
}
