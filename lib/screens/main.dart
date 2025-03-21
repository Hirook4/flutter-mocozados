import 'package:flutter/material.dart';
import 'package:mocozados/screens/login.dart';
import 'package:mocozados/screens/opening.dart';
import 'package:mocozados/screens/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Login(),
    );
  }
}
