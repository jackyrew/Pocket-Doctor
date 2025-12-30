import 'package:flutter/material.dart';

import 'package:pocket_doctor/widgets/bottom_nav.dart';
import 'package:pocket_doctor/screens/home_existing_user.dart';
import 'package:pocket_doctor/screens/home_new_user.dart';
import 'package:pocket_doctor/screens/profile_page.dart';
import 'package:pocket_doctor/screens/medicine_timer_page.dart';
// later you can add chat & reminder pages

class NavWrapper extends StatefulWidget {
  final String userName;
  final String email;
  final List<Map<String, dynamic>> reminders;

  const NavWrapper({
    super.key,
    required this.userName,
    required this.email,
    required this.reminders,
  });

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      widget.reminders.isEmpty
          ? HomeNewUser(userName: widget.userName)
          : HomeExistingUser(
              userName: widget.userName,
              reminders: widget.reminders,
            ),
      const MedicineTimerPage(),
      const Placeholder(), // chat
      ProfilePage(
        userName: widget.userName,
        email: widget.email,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
