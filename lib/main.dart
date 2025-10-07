import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mocozados/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mocozados/screens/home.dart';
import 'package:mocozados/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RouteScreen(),
    );
  }
}

/* Fazer verificação se o usuario vai estar logado ou não */
/* Stream: monitora uma conexão e mantem ela em aberto */
class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        /* Se houver a informação, o usuario esta logado */
        if (snapshot.hasData) {
          return Home();
        } else {
          return Login();
        }
      },
    );
  }
}
