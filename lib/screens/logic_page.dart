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

    if (snap.exists) {
      final data = snap.value as Map;
      fullName = data["fullName"] ?? "User";
      email = data["email"] ?? "";
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NavWrapper(
          userId: uid,
          userName: fullName,
          email: email,
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
