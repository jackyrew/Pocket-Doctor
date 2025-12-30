import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pocket_doctor/screens/login_page.dart';
import 'package:pocket_doctor/screens/welcome_page.dart';
import 'package:pocket_doctor/screens/logic_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pocket Doctor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: const WelcomePage(),

      routes: {
        "/login": (_) => const LoginPage(),
        "/logic": (_) => const LogicPage(),
      },
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pocket Doctor")),
      body: const Center(
        child: Text("Firebase Initialized Successfully!"),
      ),
    );
  }
}
