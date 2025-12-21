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
      appBar: AppBar(
        title: const Text("Medicine Timer"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today activities",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            /// LIST
            Expanded(
              child: StreamBuilder(
                stream: db.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return const Center(
                      child: Text("No medicine timer yet"),
                    );
                  }

                  final data = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map,
                  );

                  return ListView(
                    children: data.entries.map((entry) {
                      final reminder = Map<String, dynamic>.from(entry.value);

                      final bool taken = reminder['taken'] ?? false;
                      final bool overdue = _isOverdue(reminder['time'], taken);

                      return _medicineCard(
                        name: reminder['name'],
                        time: reminder['time'],
                        taken: taken,
                        overdue: overdue,
                        onEdit: () {
                          _showEditTimeSheet(
                            context,
                            entry.key,
                            reminder['time'],
                          );
                        },
                        onTaken: () async {
                          final uid = FirebaseAuth.instance.currentUser!.uid;
                          final db = FirebaseDatabase.instance.ref(
                            "users/$uid/reminders/${entry.key}",
                          );

                          await db.update({"taken": true});
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            /// ADD BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Medicine Timer"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddMedicinePage(),
                    ),
                  );
                },
              ),
            ),
          ],
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
    required bool taken,
    required bool overdue,
    required VoidCallback onEdit,
    required VoidCallback onTaken,
  }) {
    Color bgColor = Colors.blue;

    if (taken) {
      bgColor = Colors.green;
    } else if (overdue) {
      bgColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(color: Colors.white),
              ),
              if (!taken)
                TextButton(
                  onPressed: onTaken,
                  child: const Text(
                    "Mark as Taken",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              if (taken)
                const Text(
                  "Taken",
                  style: TextStyle(color: Colors.white),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
