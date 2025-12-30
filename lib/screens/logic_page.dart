import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

    db = FirebaseDatabase.instance.ref();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserStatus();
    });
  }

  Future<void> _checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    // 🔴 USER NOT LOGGED IN
    if (user == null) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    final uid = user.uid;
    final snap = await db.child("users/$uid").get();

    if (!mounted) return;

    String fullName = "User";
    String email = "";
    List<Map<String, dynamic>> reminderList = [];

    if (snap.exists) {
      final data = snap.value as Map;
      fullName = data["fullName"] ?? "User";
      email = data["email"] ?? "";

      final reminders = data["reminders"];
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
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NavWrapper(
          userName: fullName,
          email: email,
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
