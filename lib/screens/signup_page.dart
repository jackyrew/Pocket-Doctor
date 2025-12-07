import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:pocket_doctor/screens/logic_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  String selectedGender = "Male";
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // your textfields here...
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),

            TextField(
              controller: age,
              decoration: const InputDecoration(labelText: "Age"),
            ),

            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: pass,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 10),

            // gender
            DropdownButton<String>(
              value: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: "Male", child: Text("Male")),
                DropdownMenuItem(value: "Female", child: Text("Female")),
              ],
            ),

            const SizedBox(height: 20),

            // 🔥 Your actual button with the functional onPressed
            ElevatedButton(
              onPressed: () async {
                if (name.text.isEmpty ||
                    email.text.isEmpty ||
                    pass.text.isEmpty)
                  return;

                final auth = AuthService();

                String? error = await auth.signUp(
                  fullName: name.text.trim(),
                  age: age.text.trim(),
                  gender: selectedGender,
                  email: email.text.trim(),
                  password: pass.text.trim(),
                );

                if (error == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LogicPage()),
                  );
                } else {
                  setState(() => errorText = error);
                }
              },
              child: const Text("Sign Up"),
            ),

            if (errorText != null)
              Text(
                errorText!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
