import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/medicine_reminder.dart';
import 'add_edit_medicine_page.dart';

class MedicineTimerPage extends StatefulWidget {
  const MedicineTimerPage({super.key});

  @override
  State<MedicineTimerPage> createState() => _MedicineTimerPageState();
}

class _MedicineTimerPageState extends State<MedicineTimerPage> {
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),

            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: db.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return _emptyState(context);
                  }

                  final data = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map,
                  );

                  final reminders = data.entries.map((e) {
                    final value = Map<String, dynamic>.from(e.value);
                    return MedicineReminder.fromMap(e.key, value);
                  }).toList();

                  // 🔹 STEP 1: split reminders into categories
                  final overdueList = <MedicineReminder>[];
                  final todayList = <MedicineReminder>[];
                  final takenList = <MedicineReminder>[];

                  for (final r in reminders) {
                    final value = Map<String, dynamic>.from(data[r.id]);

                    final takenToday = _isTakenToday(value['lastTakenDate']);
                    final overdue = _isOverdue(r.time, takenToday);

                    if (takenToday) {
                      takenList.add(r);
                    } else if (overdue) {
                      overdueList.add(r);
                    } else {
                      todayList.add(r);
                    }
                  }

                  if (reminders.isEmpty) {
                    return _emptyState(context);
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    children: [
                      // 🔴 OVERDUE SECTION
                      if (overdueList.isNotEmpty) ...[
                        const Text(
                          "Overdue activities",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "You missed a dose!",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 12),

                        ...overdueList.map((r) {
                          return _slidableCard(
                            context: context,
                            r: r,
                            takenToday: false,
                            overdue: true,
                            db: db,
                            onTaken: () async {
                              final today = DateTime.now()
                                  .toIso8601String()
                                  .split("T")[0];
                              await db.child(r.id).update({
                                "lastTakenDate": today,
                              });
                            },
                          );
                        }),

                        const SizedBox(height: 24),
                      ],

                      // 🔵 TODAY SECTION
                      if (todayList.isNotEmpty) ...[
                        const Text(
                          "Today activities",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        ...todayList.map((r) {
                          return _slidableCard(
                            context: context,
                            r: r,
                            takenToday: false,
                            overdue: false,
                            db: db,
                            onTaken: () async {
                              final today = DateTime.now()
                                  .toIso8601String()
                                  .split("T")[0];
                              await db.child(r.id).update({
                                "lastTakenDate": today,
                              });
                            },
                          );
                        }),

                        const SizedBox(height: 24),
                      ],

                      // 🟢 TAKEN SECTION
                      if (takenList.isNotEmpty) ...[
                        const Text(
                          "Taken today",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        ...takenList.map((r) {
                          return _slidableCard(
                            context: context,
                            r: r,
                            takenToday: true,
                            overdue: false,
                            db: db,
                            onTaken: () async {
                              final today = DateTime.now()
                                  .toIso8601String()
                                  .split("T")[0];
                              await db.child(r.id).update({
                                "lastTakenDate": today,
                              });
                            },
                          );
                        }),
                      ],

                      //add button
                      const SizedBox(height: 18),
                      _addMedicineButton(context),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isTakenToday(String? lastTakenDate) {
    if (lastTakenDate == null) return false;

    final today = DateTime.now().toIso8601String().split("T")[0];
    return lastTakenDate == today;
  }

  bool _isOverdue(String time, bool takenToday) {
    if (takenToday) return false;

    final now = TimeOfDay.now();
    final parts = time.split(":");

    final reminderMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    final nowMinutes = now.hour * 60 + now.minute;

    return reminderMinutes < nowMinutes;
  }

  Widget _header(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_back_ios, size: 16),
                      SizedBox(width: 4),
                      Text("Back", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),

                const Spacer(),

                const Text(
                  "Medicine Timer",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Spacer(),

                const SizedBox(width: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Set a reminder so we can help you",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          _addMedicineButton(context),
        ],
      ),
    );
  }

  Widget _addMedicineButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditMedicinePage(),
            ),
          );

          if (added == true && mounted) {
            setState(() {});
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3E7AEB),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Add Medicine Timer",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.add_circle_outline, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _slidableCard({
    required BuildContext context,
    required MedicineReminder r,
    required bool takenToday,
    required bool overdue,
    required VoidCallback onTaken,
    required DatabaseReference db,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12), // spacing between cards
      child: Slidable(
        key: ValueKey(r.id),

        // swipe LEFT
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.46,
          children: [
            _slidableButton(
              color: const Color(0xFF3E7AEB),
              icon: Icons.edit,
              label: "Edit",
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditMedicinePage(reminder: r),
                  ),
                );
                if (updated == true && context.mounted) {
                  setState(() {});
                }
              },
            ),
            _slidableButton(
              color: Colors.red,
              icon: Icons.delete,
              label: "Delete",
              onTap: () async {
                await db.child(r.id).remove();
              },
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: _medicineCard(
            name: r.name,
            time: r.time,
            takenToday: takenToday,
            overdue: overdue,
            onEdit: () {},
            onTaken: onTaken,
          ),
        ),
      ),
    );
  }

  Widget _slidableButton({
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔵 BLUE CARD UI (keep this here)
Widget _medicineCard({
  required String name,
  required String time,
  required bool takenToday,
  required bool overdue,
  required VoidCallback onEdit,
  required VoidCallback onTaken,
}) {
  // ✅ MOVE LOGIC HERE
  final Color bgColor = takenToday
      ? Colors.green
      : overdue
      ? Colors.red
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
        Row(
          children: [
            Image.asset(
              'assets/icons/icon-medicine.png',
              width: 28,
              height: 28,
              color: Colors.white, // keeps it white on blue/red/green
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Scheduled $time",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (takenToday)
          const Center(
            child: Text(
              "Taken today",
              style: TextStyle(color: Colors.white70),
            ),
          )
        else if (overdue)
          Center(
            child: TextButton(
              onPressed: onTaken,
              child: const Text(
                "Overdue - Mark as taken",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        else
          Center(
            child: TextButton(
              onPressed: onTaken,
              child: const Text(
                "Mark as taken",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    ),
  );
}
