import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/medicine_reminder.dart';
import '../utils/time_picker.dart';

class AddEditMedicinePage extends StatefulWidget {
  final MedicineReminder? reminder;

  const AddEditMedicinePage({super.key, this.reminder});

  @override
  State<AddEditMedicinePage> createState() => _AddEditMedicinePageState();
}

class _AddEditMedicinePageState extends State<AddEditMedicinePage> {
  final _dosageController = TextEditingController();

  final _nameController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isSaving = false;

  bool get isEdit => widget.reminder != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      _nameController.text = widget.reminder!.name;
      _dosageController.text = widget.reminder!.dosage ?? "";

      final parts = widget.reminder!.time.split(":");
      _selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }
  }

  // ⏱ Time picker
  Future<void> _selectTime() async {
    final picked = await pickTime(context, _selectedTime);
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // 💾 Save to Firebase (ADD + EDIT)
  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _isSaving = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref("users/$uid/reminders");

    final timeString =
        "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}";

    final data = {
      "name": _nameController.text.trim(),
      "dosage": _dosageController.text.trim(),
      "time": timeString,
    };

    if (isEdit) {
      await ref.child(widget.reminder!.id).update(data);
    } else {
      await ref.push().set({
        ...data,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Medicine"),
          content: const Text(
            "Are you sure you want to delete this medicine timer?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref(
      "users/$uid/reminders/${widget.reminder!.id}",
    );

    await ref.remove();

    if (!mounted) return;
    Navigator.pop(context, true); // notify previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            // CANCEL
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),

            const Spacer(),

            // TITLE
            const Text(
              "Medicine Timer",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            // SAVE
            // RIGHT ACTION (Save OR Delete)
            GestureDetector(
              onTap: _isSaving
                  ? null
                  : isEdit
                  ? _delete
                  : _save,
              child: Text(
                isEdit ? "Delete" : "Save",
                style: TextStyle(
                  color: isEdit ? Colors.red : const Color(0xFF3E7AEB),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _formContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Medication",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 20),

        const Text("Medication Name"),
        const SizedBox(height: 6),
        TextField(
          controller: _nameController,
          decoration: _inputDecoration("Pantoprazole"),
        ),
        const SizedBox(height: 16),

        const Text("Dosage"),
        const SizedBox(height: 6),
        TextField(
          controller: _dosageController,
          decoration: _inputDecoration("1 Tablet"),
        ),

        const SizedBox(height: 16),
        const Text("Start Time"),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: _inputBox(),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 8),
                Text(_selectedTime.format(context)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E7AEB),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Add",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF1F3F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  BoxDecoration _inputBox() {
    return BoxDecoration(
      color: const Color(0xFFF1F3F5),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
