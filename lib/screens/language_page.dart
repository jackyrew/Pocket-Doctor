import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLanguage = "English";

  @override
  void initState() {
    super.initState();
  }

  void _onLanguageChanged(String? value) {
    if (value != null) {
      setState(() {
        selectedLanguage = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // IOS STYLE APPBAR
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Language"),
          previousPageTitle: "Back",
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _cupertino("Malay"),
                _cupertino("English"),
              ],
            ),
          ),
        ),
      );
    } else {
      // ANDROID STYLE APPBAR
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
            "Language",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _material("Malay"),
                _material("English"),
              ],
            ),
          ),
        ),
      );
    }
  }

  // ANDROID RADIO TILE (CHOOSE LANGUAGE MALAY/ ENGLISH)
  Widget _material(String value) {
    return RadioListTile<String>(
      title: Text(value),
      value: value,
      groupValue: selectedLanguage,
      onChanged: _onLanguageChanged,
      activeColor: const Color(0xFF3E7AEB),
    );
  }

  // IOS RADIO TILE (CHOOSE LANGUAGE MALAY / ENGLISH)
  Widget _cupertino(String value) {
    return CupertinoFormRow(
      prefix: Text(value),
      child: CupertinoSwitch(
        value: selectedLanguage == value,
        onChanged: (bool selected) {
          if (selected) _onLanguageChanged(value);
        },
        activeColor: const Color(0xFF3E7AEB),
      ),
    );
  }
}
