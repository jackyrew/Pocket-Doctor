import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pocket_doctor/theme/colors.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  String? _gender;
  DateTime? _dateOfBirth;

  late final User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadName();
    _loadProfileData();
  }

  void _loadName() {
    final name = _user.displayName;
    if (name == null) return;

    final parts = name.split(" ");
    _firstNameController.text = parts.first;
    if (parts.length > 1) {
      _lastNameController.text = parts.sublist(1).join(" ");
    }
  }

  void _loadProfileData() async {
    final snapshot = await FirebaseDatabase.instance
        .ref("users/${_user.uid}/profile")
        .get();

    final data = snapshot.value as Map?;
    if (data == null) return;

    setState(() {
      _gender = data['gender'];
      if (data['dob'] != null) {
        _dateOfBirth = DateTime.tryParse(data['dob']);
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF3E7AEB);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Account",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAvatar(),
            const SizedBox(height: 30),

            _buildTextField("First name", _firstNameController),
            _buildTextField("Last name", _lastNameController),
            _buildGenderField(),
            _buildDateOfBirthField(),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Update Profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _buildAvatar() {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 45,
          backgroundImage: AssetImage("assets/icons/User-image.png"),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: primaryBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: _showGenderPicker,
        child: InputDecorator(
          decoration: const InputDecoration(
            hintText: "Select your gender",
            border: UnderlineInputBorder(),
          ),
          child: Text(_gender ?? "Select your gender"),
        ),
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: _selectDateOfBirth,
        child: InputDecorator(
          decoration: const InputDecoration(
            hintText: "Date of Birth",
            border: UnderlineInputBorder(),
          ),
          child: Text(
            _dateOfBirth != null
                ? "${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}"
                : "Select your date of birth",
          ),
        ),
      ),
    );
  }

  // ---------------- ACTIONS ----------------

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ["Male", "Female"].map((gender) {
          return ListTile(
            title: Text(gender),
            onTap: () {
              setState(() => _gender = gender);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  Future<void> _selectDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _updateProfile() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _gender == null ||
        _dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      ); return;
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );Navigator.pop(context);
    }

    final fullName =
        "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}";

    await _user.updateDisplayName(fullName);

    await FirebaseDatabase.instance
        .ref("users/${_user.uid}/profile")
        .update({
      "name": fullName,
      "gender": _gender,
      "dob": _dateOfBirth!.toIso8601String(),
    });

    if (!mounted) return;
    Navigator.pop(context, true);
  }
}
