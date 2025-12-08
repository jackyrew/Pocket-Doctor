import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:pocket_doctor/screens/login_page.dart';
import 'package:pocket_doctor/screens/logic_page.dart';
import '../theme/colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String gender = "Male";
  bool _obscurePassword = true;

  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/icons/bear-logo.png",
                  height: 120,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Sign up to get started with Pocket Doctor",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 35),

              // FULL NAME
              TextField(
                controller: _fullName,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                ),
              ),

              const SizedBox(height: 20),

              // AGE
              TextField(
                controller: _age,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                ),
              ),

              const SizedBox(height: 20),

              // GENDER DROPDOWN
              DropdownButtonFormField<String>(
                value: gender,
                items: ["Male", "Female", "Other"]
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  gender = value!;
                },
                decoration: const InputDecoration(
                  labelText: "Gender",
                ),
              ),

              const SizedBox(height: 20),

              // EMAIL
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD WITH TOGGLE
              TextField(
                controller: _password,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ERROR MESSAGE
              if (errorText != null)
                Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 30),

              // SIGN UP BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    if (_fullName.text.isEmpty ||
                        _age.text.isEmpty ||
                        _email.text.isEmpty ||
                        _password.text.isEmpty) {
                      setState(() => errorText = "Please fill all fields");
                      return;
                    }

                    final auth = AuthService();
                    String? error = await auth.signUp(
                      fullName: _fullName.text.trim(),
                      age: _age.text.trim(),
                      gender: gender,
                      email: _email.text.trim(),
                      password: _password.text.trim(),
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
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // LOGIN LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
