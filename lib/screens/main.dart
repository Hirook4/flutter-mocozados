import 'package:firebase_core/firebase_core.dart';
import 'package:mocozados/firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:mocozados/screens/login.dart';
import 'package:mocozados/screens/opening.dart';
import 'package:mocozados/screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
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
