import 'package:flutter/material.dart';
import 'package:pocket_doctor/screens/add_medicine_page.dart';

class HomeExistingUser extends StatelessWidget {
  final String userName;
  final List<Map<String, dynamic>> reminders;

  const HomeExistingUser({
    super.key,
    required this.userName,
    required this.reminders,
  });

  @override
  Widget build(BuildContext context) {
    // For now, just show first reminder if exists
    final Map<String, dynamic>? nextReminder = reminders.isNotEmpty
        ? reminders.first
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: logo + app name + profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/bear-logo.png", height: 40),
                      const SizedBox(width: 10),
                      const Text(
                        "Pocket Doctor",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFE9F3FF),
                    child: const Icon(Icons.person, color: Colors.black54),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Greeting
              Text(
                "Hi, $userName 👋",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              // TODO: replace with your exact subtitle
              const Text(
                "Here’s what’s coming up for today.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 24),

              // Next reminder card (blue)
              if (nextReminder != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3E7AEB),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TODO: adjust text to match Figma exactly
                      const Text(
                        "Next reminder",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${nextReminder['name'] ?? 'Medicine name'}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${nextReminder['time'] ?? 'Time'}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Text(
                  "No reminders found for today.",
                  style: TextStyle(color: Colors.black54),
                ),

              const SizedBox(height: 24),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddMedicinePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E7AEB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    "Add Medicine Timer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
