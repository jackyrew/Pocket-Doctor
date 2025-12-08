import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home_new_user.dart';
import 'nav_wrapper.dart';

class LogicPage extends StatefulWidget {
  const LogicPage({super.key});

  @override
  State<LogicPage> createState() => _LogicPageState();
}

class _LogicPageState extends State<LogicPage> {
  late final DatabaseReference db;

  @override
  void initState() {
    super.initState();

    // connect to the correct database (asia-southeast1)
    db = FirebaseDatabase.instanceFor(
      app: Firebase.app("PocketDoctor"),
      databaseURL:
          "https://pocket-doctor-b5458-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref();

    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snap = await db.child("users/$uid").get();

    if (!mounted) return;

    // 🔹 User does NOT exist → treat as new user
    if (!snap.exists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeNewUser(userName: "User"),
        ),
      );
      return;
    }

    // 🔹 Extract user data
    final data = snap.value as Map;
    final String fullName = data["fullName"] ?? "User";
    final reminders = data["reminders"];

    // 🔹 User exists but has no reminders → new user home
    if (reminders == null || reminders.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeNewUser(
            userName: fullName,
          ),
        ),
      );
      return;
    }

    // 🔹 Convert reminders Map → List<Map> (for NavWrapper)
    final List<Map<String, dynamic>> reminderList = [];
    if (reminders is Map) {
      reminders.forEach((key, value) {
        if (value is Map) {
          reminderList.add({
            "id": key,
            "name": value["name"],
            "time": value["time"],
          });
        }
      });
    }

    // 🔹 Existing user with reminders → NavWrapper
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NavWrapper(
          userName: fullName,
          reminders: reminderList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
