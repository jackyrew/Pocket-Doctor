import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:pocket_doctor/screens/reset_email_sent_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _email = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Your email input field here...
          const SizedBox(height: 20),

          // 🔥 RESET PASSWORD BUTTON
          ElevatedButton(
            onPressed: () async {
              final auth = AuthService();
              String? error = await auth.resetPassword(_email.text.trim());

              if (error == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ResetEmailSentPage(),
                  ),
                );
              } else {
                setState(() => errorText = error);
              }
            },
            child: const Text("Submit"),
          ),

          if (errorText != null)
            Text(
              errorText!,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
