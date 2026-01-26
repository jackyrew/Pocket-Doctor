import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/medicine_notification_service.dart';
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
  int _intervalHours = 6;
  String _repeat = "daily";
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
      _intervalHours = widget.reminder!.intervalHours;
      _repeat = widget.reminder!.repeat;

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

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final ref = FirebaseDatabase.instance.ref("users/$uid/reminders");

      // ✅ 1. Build time string FIRST
      final timeString =
          "${_selectedTime.hour.toString().padLeft(2, '0')}:"
          "${_selectedTime.minute.toString().padLeft(2, '0')}";

      // ✅ 4. Save to Firebase
      final data = {
        "name": _nameController.text.trim(),
        "dosage": _dosageController.text.trim(),
        "time": timeString,
        "intervalHours": _intervalHours,
        "repeat": _repeat,
      };

      String reminderId;

      if (isEdit) {
        reminderId = widget.reminder!.id;
        await ref.child(reminderId).update(data);

        // cancel old notification
        await MedicineNotificationService.cancelReminder(reminderId);
      } else {
        final newRef = ref.push();
        reminderId = newRef.key!;
        await newRef.set({
          ...data,
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        });
      }

      // schedule new notification
      await MedicineNotificationService.scheduleReminder(
        reminderId: reminderId,
        medicineName: _nameController.text.trim(),
        time: timeString,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e, s) {
      debugPrint("❌ SAVE ERROR: $e");
      debugPrint("STACKTRACE: $s");

      if (mounted) {
        setState(() => _isSaving = false);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving reminder: $e")),
      );
    }
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

    await MedicineNotificationService.cancelReminder(widget.reminder!.id);
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

        const SizedBox(height: 16),
        const Text("Interval"),
        const SizedBox(height: 6),
        _styledDropdown<int>(
          value: _intervalHours,
          items: const [
            DropdownMenuItem(value: 6, child: Text("6 Hours")),
            DropdownMenuItem(value: 8, child: Text("8 Hours")),
            DropdownMenuItem(value: 12, child: Text("12 Hours")),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _intervalHours = value);
            }
          },
        ),

        const SizedBox(height: 16),
        const Text("Repeat"),
        const SizedBox(height: 6),
        _styledDropdown<String>(
          value: _repeat,
          items: const [
            DropdownMenuItem(value: "daily", child: Text("Every Day")),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _repeat = value);
            }
          },
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

  static const Color _fieldBgColor = Color(0xFFF1F3F5);

  static const TextStyle _fieldTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Color(0xFF2F2F2F),
  );

  Widget _styledDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _fieldBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black45,
          ),
          style: _fieldTextStyle,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
