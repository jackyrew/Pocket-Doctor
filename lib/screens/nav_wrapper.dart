import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'home_existing_user.dart';

class NavWrapper extends StatefulWidget {
  final String userName;
  final List<Map<String, dynamic>> reminders;

  const NavWrapper({
    super.key,
    required this.userName,
    required this.reminders,
  });

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeExistingUser(
        userName: widget.userName,
        reminders: widget.reminders,
      ),
      const Placeholder(), // Timer page (future)
      const Placeholder(), // Chat page (future)
      const Placeholder(), // Profile page (future)
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
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
