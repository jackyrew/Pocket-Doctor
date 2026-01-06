import 'package:flutter/material.dart';
import 'package:pocket_doctor/chat/screens/chatbot_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pocket_doctor/firebase_options.dart';
import 'package:pocket_doctor/screens/login_page.dart';
import 'package:pocket_doctor/screens/welcome_page.dart';
import 'package:pocket_doctor/screens/logic_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

// 🔔 GLOBAL NOTIFICATION PLUGIN
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔔 Init time zones
  tz.initializeTimeZones();

  // 🔔 Init notifications
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(const PocketDoctorApp());
} // ✅ THIS WAS MISSING

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
