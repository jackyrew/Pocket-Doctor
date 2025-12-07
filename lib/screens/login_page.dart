import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:pocket_doctor/screens/signup_page.dart';
import 'package:pocket_doctor/screens/logic_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // email
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            // password
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 10),

            // error message
            if (errorText != null)
              Text(
                errorText!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),

            // 👉 YOUR BUTTON GOES HERE
            ElevatedButton(
              onPressed: () async {
                final auth = AuthService();

                String? error = await auth.login(
                  email: _email.text.trim(),
                  password: _password.text.trim(),
                );

                if (error == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LogicPage(),
                    ),
                  );
                } else {
                  setState(() {
                    errorText = "Invalid username or password";
                  });
                }
              },
              child: const Text("Login"),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
