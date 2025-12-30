import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'add_medicine_page.dart';

class MedicineTimerPage extends StatelessWidget {
  const MedicineTimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    final uid = user.uid;
    final db = FirebaseDatabase.instance.ref("users/$uid/reminders");

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(height: 16),
            _subtitle(),
            const SizedBox(height: 16),
            Expanded(child: _reminderList(db)),

            const SizedBox(height: 12),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: _addMedicineButton(context),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text("‹ Back", style: TextStyle(fontSize: 16)),
          ),
          const Spacer(),
          const Text(
            "Medicine Timer",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _subtitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Set a reminder so we can help you",
        style: TextStyle(fontSize: 14, color: Colors.black54),
      ),
    );
  }

  //list
  Widget _reminderList(DatabaseReference db) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder(
        stream: db.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No medicine timer yet"));
          }

          final data = Map<String, dynamic>.from(
            snapshot.data!.snapshot.value as Map,
          );

          return ListView(
            children: data.entries.map((entry) {
              final reminder = Map<String, dynamic>.from(entry.value);

              final bool takenToday = _isTakenToday(reminder['lastTakenDate']);
              final bool overdue = _isOverdue(reminder['time'], takenToday);

              return _medicineCard(
                name: reminder['name'],
                time: reminder['time'],
                takenToday: takenToday,
                overdue: overdue,
                onEdit: () {
                  _showEditTimeSheet(
                    context,
                    entry.key,
                    reminder['time'],
                  );
                },
                onTaken: () async {
                  final today = DateTime.now().toIso8601String().split("T")[0];

                  await db.child(entry.key).update({
                    "taken": true,
                    "lastTakenDate": today,
                  });
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _addMedicineButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMedicinePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3E7AEB),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              const SizedBox(width: 6),

              // TEXT
              const Text(
                "Add Medicine Timer",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const Spacer(),

              // BUTTON
              Container(
                width: 36, // circle size
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_alarm,
                  size: 22,
                  color: Color(0xFF3E7AEB),
                ),
              ),

              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditTimeSheet(
    BuildContext context,
    String reminderId,
    String oldTime,
  ) {
    TimeOfDay selected = _parseTime(oldTime);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Edit Time",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selected,
                      );

                      if (picked != null) {
                        setState(() => selected = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selected.format(context)),
                          const Icon(Icons.access_time),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text("Save"),
                      onPressed: () async {
                        final uid = FirebaseAuth.instance.currentUser!.uid;

                        final db = FirebaseDatabase.instance.ref(
                          "users/$uid/reminders/$reminderId",
                        );

                        final formatted =
                            selected.hour.toString().padLeft(2, '0') +
                            ":" +
                            selected.minute.toString().padLeft(2, '0');

                        await db.update({"time": formatted});

                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showDeleteConfirm(context, reminderId);
                    },
                    child: const Text(
                      "Delete Alarm",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  bool _isOverdue(String time, bool taken) {
    if (taken) return false;

    final now = TimeOfDay.now();
    final reminder = _parseTime(time);

    final nowMinutes = now.hour * 60 + now.minute;
    final reminderMinutes = reminder.hour * 60 + reminder.minute;

    return nowMinutes > reminderMinutes;
  }

  bool _isTakenToday(String? lastTakenDate) {
    if (lastTakenDate == null) return false;

    final today = DateTime.now().toIso8601String().split("T")[0];
    return lastTakenDate == today;
  }

  void _showDeleteConfirm(BuildContext context, String reminderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Reminder"),
          content: const Text(
            "Are you sure you want to delete this medicine timer?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser!.uid;

                final db = FirebaseDatabase.instance.ref(
                  "users/$uid/reminders/$reminderId",
                );

                await db.remove();

                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  /// BLUE CARD (matches your design)
  Widget _medicineCard({
    required String name,
    required String time,
    required bool takenToday,
    required bool overdue,
    required VoidCallback onEdit,
    required VoidCallback onTaken,
  }) {
    final Color bgColor = overdue
        ? const Color(0xFF3E7AEB)
        : const Color(0xFF3E7AEB);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/icons/icon-medicine.png",
                height: 28,
                color: Colors.white,
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Scheduled $time",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ACTION
          if (!takenToday)
            Center(
              child: TextButton(
                onPressed: onTaken,
                child: const Text(
                  "Mark as taken",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            const Center(
              child: Text(
                "Taken today",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
