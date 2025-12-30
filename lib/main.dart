import 'package:flutter/material.dart';
import 'package:pocket_doctor/chat/screens/chatbot_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
      title: 'Pocket Doctor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: ChatbotScreen(
        userId: fakeUserId,
        userName: fakeUserName,
      ),
    );
  }
}
