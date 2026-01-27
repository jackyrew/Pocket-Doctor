import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../services/medicine_notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isEnabled = false;
  late DatabaseReference db;

  @override
  void initState() {
    super.initState();

    // reference to user settings in firebase
    db = FirebaseDatabase.instance.ref(
      "users/${FirebaseAuth.instance.currentUser!.uid}/settings",
    );

    _loadNotificationStatus();
  }

  // load saved notification toggle value
  Future<void> _loadNotificationStatus() async {
    final snap = await db.child("notificationsEnabled").get();

    if (snap.exists && snap.value is bool) {
      setState(() {
        isEnabled = snap.value as bool;
      });
    }
  }

  // update toggle state in database
  Future<void> _updateNotification(bool value) async {
    setState(() {
      isEnabled = value;
    });

    await db.update({"notificationsEnabled": value});

    // if user turns off notification, cancel all reminders
    if (!value) {
      await MedicineNotificationService.cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Notification",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Turn on Notification so we can notify\nyou to take your medicine",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/notifications.png",
                    width: 26,
                    height: 26,
                  ),
                  const SizedBox(width: 14),

                  const Expanded(
                    child: Text(
                      "Notification",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Switch(
                    value: isEnabled,
                    activeThumbColor: const Color(0xFF3E7AEB),
                    onChanged: _updateNotification,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                MedicineNotificationService.showTestNow();
              },
              child: const Text("TEST NOTIFICATION"),
            ),
          ],
        ),
      ),
    );
  }
}
