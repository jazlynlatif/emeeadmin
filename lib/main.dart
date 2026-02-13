import 'dart:io';

import 'package:emee_admin/pages/auth-pages/login.dart';
import 'package:emee_admin/pages/dispatch/dispatch-home.dart';
import 'package:flutter/material.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
          primary: Color.fromRGBO(255, 182, 193, 1),
          primaryContainer: Color.fromRGBO(235, 235, 235, 1)
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.bold
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14
          )
        )
      ),
      home: const LoginPage(),
    );
  }
}

