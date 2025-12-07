import 'package:flutter/material.dart';

class HomeNewUser extends StatelessWidget {
  const HomeNewUser({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Welcome New User!", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
