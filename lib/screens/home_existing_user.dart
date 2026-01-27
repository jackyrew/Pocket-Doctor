import 'package:flutter/material.dart';
import 'package:pocket_doctor/screens/add_edit_medicine_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeExistingUser extends StatelessWidget {
  final String userName;

  const HomeExistingUser({
    super.key,
    required this.userName,
  });

  String _formatTime(String time) {
    final parts = time.split(":");
    if (parts.length != 2) return time;

    final hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? "PM" : "AM";
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return "$displayHour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/icons/bear-logo.png",
                        height: 36,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Pocket Doctor",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  CircleAvatar(
                    radius: 18,
                    backgroundImage: const AssetImage(
                      "assets/icons/User-image.png",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// GREETING (with hand emoji image)
              Row(
                children: [
                  Text(
                    "Hello, $userName ",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Image.asset(
                    "assets/icons/hands-emoji.png",
                    height: 22,
                  ),
                ],
              ),

              const SizedBox(height: 4),

              const Text(
                "How can I help you today?",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 24),

              /// CHECK SYMPTOMS BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, "/chatbot");
                  },
                  icon: Image.asset(
                    "assets/icons/Messages.png",
                    height: 22,
                  ),
                  label: const Text("Check Symptoms"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E7AEB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// EXPLORE MORE
              const Text(
                "Explore more",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              /// MEDICINE PROMO CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F3FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/icons/clock.png",
                        height: 70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Need a nudge? Let us remind you when it's time to take your medicine.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
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
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Add Medicine Timer"),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// TODAY’S REMINDER
              const Text(
                "Today’s Reminder",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref(
                      "users/${FirebaseAuth.instance.currentUser!.uid}/reminders",
                    )
                    .onValue,

                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return const Text(
                      "No reminders for today.",
                      style: TextStyle(color: Colors.black54),
                    );
                  }

                  final data = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map,
                  );

                  Map<String, dynamic>? todayReminder;

                  final today = DateTime.now().toIso8601String().split("T")[0];
                  final now = TimeOfDay.now();
                  int? nearestMinutes;

                  for (final entry in data.entries) {
                    final reminder = Map<String, dynamic>.from(entry.value);

                    final String time = reminder['time'];
                    final String? lastTakenDate = reminder['lastTakenDate'];

                    if (lastTakenDate == today) continue;

                    final parts = time.split(":");
                    final reminderMinutes =
                        int.parse(parts[0]) * 60 + int.parse(parts[1]);
                    final nowMinutes = now.hour * 60 + now.minute;

                    if (reminderMinutes < nowMinutes) continue;

                    if (nearestMinutes == null ||
                        reminderMinutes < nearestMinutes) {
                      nearestMinutes = reminderMinutes;
                      todayReminder = reminder;
                    }
                  }

                  if (todayReminder == null) {
                    return const Text(
                      "No reminders for today.",
                      style: TextStyle(color: Colors.black54),
                    );
                  }

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E7AEB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        "${todayReminder['name']} today  |  ${_formatTime(todayReminder['time'])}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              /// TIPS
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F3FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Center(
                      child: Text(
                        "Tips of the day",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Take meds at the same time each day for best effect. "
                      "Don’t skip your dose — set a reminder if needed.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
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
