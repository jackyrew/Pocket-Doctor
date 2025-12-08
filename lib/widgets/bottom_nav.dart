import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            index: 0,
            currentIndex: currentIndex,
            assetName: "assets/Home-button.png",
            onTap: onTap,
          ),
          _navItem(
            index: 1,
            currentIndex: currentIndex,
            assetName: "assets/Clock-button.png",
            onTap: onTap,
          ),
          _navItem(
            index: 2,
            currentIndex: currentIndex,
            assetName: "assets/Chat-button.png",
            onTap: onTap,
          ),
          _navItem(
            index: 3,
            currentIndex: currentIndex,
            assetName: "assets/Profile-button.png",
            onTap: onTap,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required int currentIndex,
    required String assetName,
    required ValueChanged<int> onTap,
  }) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Opacity(
        opacity: isActive ? 1.0 : 0.4,
        child: Image.asset(
          assetName,
          height: 28,
        ),
      ),
    );
  }
}
