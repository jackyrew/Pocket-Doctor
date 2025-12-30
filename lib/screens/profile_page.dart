import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'my_account_page.dart';
import 'setting_page.dart';
import 'notification_page.dart';
import 'help_support_page.dart';
import "package:pocket_doctor/screens/welcome_page.dart";

class ProfilePage extends StatelessWidget {
  final String userName;
  final String email;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // PROFILE CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3E7AEB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        "assets/icons/User-image.png",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // MAIN MENU
              _menuCard(context),

              const SizedBox(height: 20),

              // MORE
              const Text(
                "More",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),

              _moreCard(context),
            ],
          ),
        ),
      ),
    );
  }

  // MAIN MENU CARD
  Widget _menuCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _menuTile(
            iconPath: "assets/icons/blue-Profile.png",
            title: "My Account",
            subtitle: "Make changes to your account",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyAccountPage(),
                ),
              );
            },
          ),
          _divider(),

          _menuTile(
            iconPath: "assets/icons/setting.png",
            title: "Setting",
            subtitle: "Setting information",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingPage(),
                ),
              );
            },
          ),
          _divider(),

          _menuTile(
            iconPath: "assets/icons/notifications.png",
            title: "Notification",
            subtitle: "Enable or disable notification",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationPage(),
                ),
              );
            },
          ),
          _divider(),

          _menuTile(
            iconPath: "assets/icons/Logout.png",
            title: "Log out",
            subtitle: "Further secure your account for safety",
            onTap: () => _showLogoutPopup(context),
          ),
        ],
      ),
    );
  }

  // MENU TILE
  Widget _menuTile({
    required String iconPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 26,
        height: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black54,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.black45,
      ),
      onTap: onTap,
    );
  }

  Widget _divider() => const Divider(
    height: 1,
    thickness: 0.3,
    indent: 56,
    endIndent: 16,
  );

  // ───────────────────────── MORE CARD
  Widget _moreCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Image.asset(
          "assets/icons/blue-Notification.png",
          width: 26,
          height: 26,
        ),
        title: const Text(
          "Help & Support",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const HelpSupportPage(),
            ),
          );
        },
      ),
    );
  }

  // LOGOUT POPUP
  void _showLogoutPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            const Text(
              "Warning!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Are you sure you want to log out?\nReminders would not be notified if you do so.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (!context.mounted) return;

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
                  (route) => false, // 🔥 removes ALL previous pages
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E7AEB),
                minimumSize: const Size(150, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }
}
