import 'package:flutter/material.dart';
import 'logic_page.dart';

// The first screen shown when the app launches
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();

    // 2 second delay before moving on to LogicPage
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      // Navigate to main logic page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const LogicPage(), // Using 'ctx' for context variable
        ),
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bear logo, size might need adjusting
            Image.asset(
              "assets/icons/bear-logo.png",
              width: 200,
            ),

            const SizedBox(height: 40),

            const Text(
              "We’re loading you in..",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
