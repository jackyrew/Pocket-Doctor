import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/welcome_page.dart';
import 'screens/login_page.dart';
import 'screens/logic_page.dart';
import 'chat/screens/chatbot_screen.dart';

import 'services/medicine_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize notification service (Android only)
  await MedicineNotificationService.init();

  runApp(const PocketDoctorApp());
}

class PocketDoctorApp extends StatelessWidget {
  const PocketDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
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
