import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home_new_user.dart';
import 'home_existing_user.dart';

class LogicPage extends StatefulWidget {
  const LogicPage({super.key});

  @override
  State<LogicPage> createState() => _LogicPageState();
}

class _LogicPageState extends State<LogicPage> {
  final db = FirebaseDatabase.instanceFor(
    app: Firebase.app("PocketDoctor"),
    databaseURL:
        "https://pocket-doctor-b5458-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref();

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snap = await db.child("users/$uid").get();

    if (!mounted) return;

    if (!snap.exists) {
      // In case data not found, treat as new user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeNewUser()),
      );
      return;
    }

    final data = snap.value as Map;
    final reminders = data["reminders"];

    if (reminders == null || reminders.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeNewUser()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeExistingUser()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
