import 'package:flutter/material.dart';
import 'package:pocket_doctor/chat/screens/chatbot_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pocket_doctor/firebase_options.dart';
import 'package:pocket_doctor/screens/login_page.dart';
import 'package:pocket_doctor/screens/welcome_page.dart';
import 'package:pocket_doctor/screens/logic_page.dart';

Future<void> main() async {
  // Make sure Flutter is ready before we call async Firebase code
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase for this app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PocketDoctorApp());
}

class PocketDoctorApp extends StatelessWidget {
  const PocketDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TEMP APP: goes straight to chatbot
    const fakeUserId = 'testUser123';
    const fakeUserName = 'Test User';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const WelcomePage(),
      routes: {
        "/login": (_) => const LoginPage(),
        "/logic": (_) => const LogicPage(),
        "/chatbot": (_) => const ChatbotScreen(
          userId: fakeUserId,
          userName: fakeUserName,
        ),
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
