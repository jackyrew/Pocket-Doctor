import 'package:flutter/material.dart';

import 'package:pocket_doctor/widgets/bottom_nav.dart';
import 'package:pocket_doctor/screens/home_existing_user.dart';
import 'package:pocket_doctor/screens/profile_page.dart';
import 'package:pocket_doctor/screens/medicine_timer_page.dart';
import 'package:pocket_doctor/chat/screens/chatbot_screen.dart';
// later you can add chat & reminder pages

class NavWrapper extends StatefulWidget {
  final String userId;
  final String userName;
  final String email;

  const NavWrapper({
    super.key,
    required this.userId,
    required this.userName,
    required this.email,
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
      HomeExistingUser(userName: widget.userName),
      const MedicineTimerPage(),
      ChatbotScreen(
        userId: widget.userId,
        userName: widget.userName,
      ),
      const ProfilePage(),
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
