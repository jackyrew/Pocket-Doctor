import 'package:flutter/material.dart';
import 'logic_page.dart';

// Just a loading screen, with spinner
class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    // Small delay to simulate loading
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      // Navigate to LogicPage after delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const LogicPage(), 
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Simple loading spinner
        child: CircularProgressIndicator(
          color: Colors.blueAccent, 
          strokeWidth: 3.0,        
        ),
      ),
    );
  }
}
