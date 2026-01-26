import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_doctor/screens/add_edit_medicine_page.dart';

class HomeNewUser extends StatelessWidget {
  final String userName;

  const HomeNewUser({
    super.key,
    required this.userName,
  });

  String get _firstName => userName.split(' ').first;

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF3E7AEB);
    const lightBlue = Color(0xFFE9F3FF);
    const textDark = Color(0xFF1F1F1F);
    const textGray = Color(0xFF858585);

    final bodyContent = SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER (POCKET DOCTOR LOGO + USER PROFILE IMAGE)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/icons/bear-logo.png', height: 36),
                      const SizedBox(width: 8),
                      const Text(
                        'Pocket Doctor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: const AssetImage(
                      'assets/icons/User-image.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // GREETING THE USER (WITH HANDS EMOJI)
              Row(
                children: [
                  Image.asset('assets/icons/hands-emoji.png', height: 22),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, $_firstName",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'How can I help you today?',
                        style: TextStyle(color: textGray),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // CHECK SYMPTOMS BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chatbot');
                  },
                  icon: Image.asset('assets/icons/Messages.png', height: 22),
                  label: const Text(
                    'Check Symptoms',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // EXPLORE MORE CARD
              const Text(
                'Explore more',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/clock.png', height: 70),
                    const SizedBox(height: 8),
                    const Text(
                      "Need a nudge? Let us remind you when it's time to take your medicine.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: textDark),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddEditMedicinePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: textDark,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Add Medicine Timer"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ADD REMINDER 
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddEditMedicinePage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/icons/pills-image.png', height: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Add a medicine timer',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.add_circle_outline, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // TIPS OF THE DAY CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tips of the day',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Take meds at the same time each day for best effect."
                      " Don't skip your dose, set a reminder if needed.",
                      style: TextStyle(fontSize: 14, color: textGray),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );

    if (Platform.isIOS) {
      // IOS APPBAR
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text(
            "Home",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        child: bodyContent,
      );
    } else {
      // ANDROID APPBAR
      return Scaffold(
        backgroundColor: Colors.white,
        body: bodyContent,
      );
    }
  }
}
