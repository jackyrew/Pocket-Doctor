import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // This variable tracks if the checkbox is ticked
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text("🐨", style: TextStyle(fontSize: 50)),
            const SizedBox(height: 20),
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF333344)),
            ),
            const Text("Enter your details to sign up", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            _buildTextField("Full Name", "Ahmad Abu"),
            const SizedBox(height: 20),
            _buildTextField("Email", "example@gmail.com"),
            const SizedBox(height: 20),
            _buildTextField("Password", "min 8 characters", isPassword: true),
            const SizedBox(height: 10),

            Row(
              children: [
                Checkbox(
                  value: _isAgreed,
                  onChanged: (val) {
                    // setState tells Flutter to redraw the UI with the new value
                    setState(() => _isAgreed = val!);
                  },
                ),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "I agree with ",
                      children: [
                        TextSpan(text: "Terms ", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        TextSpan(text: "and "),
                        TextSpan(text: "Privacy Policy", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  // The button logic
                  if (_isAgreed) {
                    // If agreed, go to the login page
                    Navigator.pushNamed(context, '/login');
                  } else {
                    // Show a warning if the box isn't checked
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please agree to the Terms')),
                    );
                  }
                },
                child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF444455))),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}