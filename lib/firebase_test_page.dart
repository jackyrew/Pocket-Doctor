import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseTestPage extends StatelessWidget {
  const FirebaseTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://pocket-doctor-b5458-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref();

    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Test")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await db.child("test").set({"message": "Hello Firebase!"});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Write OK! Check Firebase DB")),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("ERROR: $e")),
              );
            }
          },
          child: const Text("Write to Firebase"),
        ),
      ),
    );
  }
}
