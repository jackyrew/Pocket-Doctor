import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Color _iconColor(int index) {
    return currentIndex == index
        ? const Color(0xFF3E7AEB) // active blue
        : Colors.grey; // inactive
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, "assets/icons/Home-button.png"),
          _navItem(1, "assets/icons/Clock-button.png"),
          _navItem(2, "assets/icons/Chat-button.png"),
          _navItem(3, "assets/icons/Profile-button.png"),
        ],
      ),
    );
  }

  Widget _navItem(int index, String iconPath) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Image.asset(
        iconPath,
        width: 26,
        height: 26,
        color: _iconColor(index),
      ),
    );
  }
}
