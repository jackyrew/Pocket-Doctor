import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "PocketDoctor",
    options: const FirebaseOptions(
      apiKey: "AIzaSyCoK4HX46UrhyWgAg2W_RXSvsUV3lWtbN0",
      appId: "1:173959701132:android:293c887dd0cfde498111a9",
      messagingSenderId: "173959701132",
      projectId: "pocket-doctor-b5458",
      databaseURL:
          "https://pocket-doctor-b5458-default-rtdb.asia-southeast1.firebasedatabase.app",
    ),
  );
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

      home: const LoginPage(),
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
