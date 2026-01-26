import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'nav_wrapper.dart';

class LogicPage extends StatefulWidget {
  const LogicPage({super.key});

  @override
  State<LogicPage> createState() => _LogicPageState();
}

class _LogicPageState extends State<LogicPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserStatus();
    });
  }

  Future<void> _checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    // USER NOT LOGGED IN
    if (user == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    // Get user info from Firebase Auth
    final uid = user.uid;
    final fullName = user.displayName ?? "User";
    final email = user.email ?? "";

    if (!mounted) return;

    // Navigate to app
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
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
