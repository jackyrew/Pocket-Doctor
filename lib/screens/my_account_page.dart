import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  // controllers for text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  String? selectedGender;
  DateTime? selectedDate;

  User? user;

  @override
  void initState() {
  super.initState();
  user = FirebaseAuth.instance.currentUser;

  // Load first & last name when name is available (the user already updated profile)
  if (user?.displayName != null) {
    List<String> parts = user!.displayName!.split(" ");
    firstNameController.text = parts.first;
    if (parts.length > 1) {
      lastNameController.text = parts.sublist(1).join(" ");
    }
  }

  // Load gender and date of birth from Realtime Database when available (the user already updated profile)
  FirebaseDatabase.instance
      .ref("users/${user!.uid}/profile")
      .once()
      .then((snapshot) {
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      setState(() {
        selectedGender = data['gender']?.toString();
        if (data['dob'] != null && data['dob'].toString().isNotEmpty) {
          selectedDate = DateTime.tryParse(data['dob'].toString());
        }
      });
    }
  });
}


  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF3E7AEB);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Account",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Stack(
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
                      color: Color(0xFF3E7AEB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              user?.displayName ?? "User", // Show "User" if displayName is null
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              user?.email ?? "", // Show empty string if email is null
              style: const TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 30),

            // First Name
            buildTextField("First name", firstNameController),

            // Last Name
            buildTextField("Last name", lastNameController),

            // Gender
            buildGenderField(),

            // Date of Birth
            buildDateOfBirthField(),

            const SizedBox(height: 30),

            // UPDATE PROFILE BUTTON
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
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  // TEXT FIELD HELPER
  Widget buildTextField(String label, TextEditingController controller) {
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

  // GENDER FIELD
  Widget buildGenderField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: _showGenderPicker,
        child: InputDecorator(
          decoration: const InputDecoration(
            hintText: "Select your gender",
            border: UnderlineInputBorder(),
          ),
          child: Text(selectedGender ?? "Select your gender"),
        ),
      ),
    );
  }

  void _showGenderPicker() {
    List<String> genders = ["Male", "Female"];
      // ANDROID (MATERIAL STYLE)
      showModalBottomSheet(
        context: context,
        builder: (_) => ListView(
          shrinkWrap: true,
          children: genders
              .map(
                (g) => ListTile(
                  title: Text(g),
                  onTap: () {
                    setState(() {
                      selectedGender = g;
                    });
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      );
    }
  

  // DATE OF BIRTH FIELD
  Widget buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: _selectDateOfBirth,
        child: InputDecorator(
          decoration: const InputDecoration(
            hintText: "Date of Birth",
            border: UnderlineInputBorder(),
          ),
          child: Text(selectedDate != null
              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
              : "Select your date of birth"),
        ),
      ),
    );
  }

  void _selectDateOfBirth() async {
      // ANDROID DATE PICKER
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime(2000, 1, 1),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() {
          selectedDate = picked;
        });
      }
    }
  

  // UPDATE PROFILE BUTTON HANDLER
  void _updateProfile() async {
    if (user == null) return;

    // Validate fields (ensure it is not empty)
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        selectedGender == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    String fullName =
        "${firstNameController.text.trim()} ${lastNameController.text.trim()}";

    await user!.updateDisplayName(fullName);

    // Save in Realtime Database
    await FirebaseDatabase.instance.ref("users/${user!.uid}/profile").update({
      "name": fullName,
      "gender": selectedGender,
      "dob": selectedDate!.toIso8601String(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );

    Navigator.pop(context);
  }
}
