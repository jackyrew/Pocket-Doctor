import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    //content of the page is the same for both platforms, thus just change the appbar
    final bodyContent = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // INTRO
          Text(
            "Welcome to Pocket Doctor's Help & Support page. "
            "If you're experiencing issues or need guidance using the app, you're in the right place.",
            style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
          ),
          SizedBox(height: 24),

          // SECTION 1
          Text(
            "How does Pocket Doctor work?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Pocket Doctor provides basic health guidance based on the symptoms you describe. "
            "It gives general suggestions to help you understand what might be going on and what to do next.",
            
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
          SizedBox(height: 24),

          // SECTION 2
          Text(
            "Can I use this in an emergency?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "No. Pocket Doctor is not for emergencies."
            " If you're having severe symptoms like chest pain, difficulty breathing, or "
            "sudden confusion, please call emergency services or go to the nearest clinic immediately.",
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
          SizedBox(height: 24),

          // SECTION 3
          Text(
            "Is this a replacement for a real doctor?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "No. This app offers general information only.  "
            "For diagnosis or medical treatment, always consult a licensed healthcare provider.",
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
          SizedBox(height: 24),

          // SECTION 4
          Text(
            "Is my data safe?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "As this is a prototype, no personal or health data is stored. "
            "In the future, proper privacy and security measures will be implemented.",
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
          SizedBox(height: 40),
        ],
      ),
    );

    if (Platform.isIOS) {
      // IOS APPBAR
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text(
            "Help & Support",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          previousPageTitle: "Back",
        ),
        child: SafeArea(child: bodyContent),
      );
    } else {
      // ANDROID APPBAR
      return Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Help & Support",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: bodyContent,
      );
    }
  }
}
