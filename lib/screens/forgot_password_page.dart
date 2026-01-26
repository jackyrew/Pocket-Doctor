import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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
              final currentContext = context; // ✅ capture context early
              final auth = AuthService();

              String? error = await auth.resetPassword(_email.text.trim());

              if (!currentContext.mounted) return;

              if (error == null) {
                Navigator.push(
                  currentContext,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordPage(),
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
