import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = "Terms & Condition";
    // IOS STYLE APPBAR
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
          previousPageTitle: 'Back',
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _termsContent(),
          ),
        ),
      );
    } else {
      // ANDROID STYLE APPBAR 
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _termsContent(),
        ),
      );
    }
  }

  Widget _termsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Our App Terms & Conditions",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text(
          "Pocket Doctor is a prototype app that offers basic health guidance "
          "based on symptoms you enter. It is not a substitute for professional "
          "medical advice, diagnosis, or treatment.\n\n"
          "The responses generated are based on limited user input and should not "
          "be considered complete or fully accurate. Always consult a licensed "
          "medical professional for any serious, unclear, or persistent symptoms.\n\n"
          "This app does not support emergencies. If you are experiencing chest pain, "
          "difficulty breathing, severe headaches, or any life-threatening symptoms, "
          "contact emergency services or visit the nearest clinic immediately.\n\n"
          "As a prototype, Pocket Doctor does not collect or store any personal health "
          "information. In future versions, appropriate data privacy and security "
          "measures will be implemented in accordance with applicable laws and "
          "university policies.\n\n"
          "By using this app, you acknowledge its limitations and agree that you are "
          "responsible for any actions taken based on the information provided.",
          style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
        ),
      ],
    );
  }
}
