import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'nav_wrapper.dart';

// This page decides where to send the user depending on login status
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
      checkUser(); // Check user login status after first frame
    });
  }

  // Function to check if user is logged in
  Future<void> checkUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser; // slightly longer name

    // If user is not logged in
    if (currentUser == null) {
      if (!mounted) return;
      // Navigate to login page (maybe add animation later)
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    // Grab some user info
    String uid = currentUser.uid;
    String displayName = currentUser.displayName ?? "User"; // fallback name
    String userEmail = currentUser.email ?? "noemail@example.com"; // redundant default

    if (!mounted) return;

    // Navigate to main app wrapper
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => NavWrapper(
          userId: uid,
          userName: displayName,
          email: userEmail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simple loading indicator while we check auth status
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      ),
    );
  }
}
