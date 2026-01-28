import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'my_account_page.dart';
import 'setting_page.dart';
import 'notification_page.dart';
import 'help_support_page.dart';
import 'package:pocket_doctor/screens/welcome_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? "User";
    final userEmail = user?.email ?? "No email";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageTitle(),
              const SizedBox(height: 20),
              
              _buildProfileCard(userName, userEmail),
              const SizedBox(height: 20),
              
              _buildMainMenuSection(context),
              const SizedBox(height: 20),
              
              _buildMoreSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // PROFILE PAGE TITLE
  // optimization of using builder method, referenced by Gemini
  Widget _buildPageTitle() {
    return const Text(
      "Profile",
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F1F1F),
      ),
    );
  }

  // PROFILE CARD SHOWING USER NAME AND EMAIL
  Widget _buildProfileCard(String name, String email) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3E7AEB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/icons/User-image.png"),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MAIN MENU SECTION
  Widget _buildMainMenuSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context: context,
            iconPath: "assets/icons/blue-Profile.png",
            title: "My Account",
            subtitle: "Make changes to your account",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyAccountPage()),
              );
            },
          ),
          _buildDivider(),
          
          _buildMenuItem(
            context: context,
            iconPath: "assets/icons/setting.png",
            title: "Settings",
            subtitle: "Customize your experience",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingPage()),
              );
            },
          ),
          _buildDivider(),
          
          _buildMenuItem(
            context: context,
            iconPath: "assets/icons/notifications.png",
            title: "Notifications",
            subtitle: "Manage notification preferences",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },
          ),
          _buildDivider(),
          
          _buildMenuItem(
            context: context,
            iconPath: "assets/icons/Logout.png",
            title: "Log Out",
            subtitle: "Sign out of your account",
            onTap: () => _handleLogout(context),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  // SINGLE MENU ITEM
  Widget _buildMenuItem({
    required BuildContext context,
    required String iconPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      leading: Image.asset(
        iconPath,
        width: 26,
        height: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red.shade700 : const Color(0xFF1F1F1F),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black54,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDestructive ? Colors.red.shade300 : Colors.black45,
      ),
      onTap: onTap,
    );
  }

  // DIVIDER BETWEEN MENU ITEMS
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.3,
      indent: 58,
      endIndent: 16,
    );
  }

  // MORE SECTION (HELP & SUPPORT)
  Widget _buildMoreSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "More",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 10),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
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
                color: Color(0xFF1F1F1F),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black45,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpSupportPage()),
              );
            },
          ),
        ),
      ],
    );
  }

  // HANDLE THE LOGOUT PROCESS
  void _handleLogout(BuildContext context) {
    // ANDROID (material dialog)
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: Color(0xFF3E7AEB),
              size: 50,
            ),
            const SizedBox(height: 16),
            const Text(
              "Log Out?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Are you sure you want to log out? You won't receive reminder notifications while signed out.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      side: const BorderSide(
                        color: Color(0xFF3E7AEB),
                        width: 1.5,
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3E7AEB),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _performLogout(context, dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF3E7AEB),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }




  // PERFORM THE ACTUAL LOGOUT, referenced by Chatgpt, 27/1/2026 1:42AM
  Future<void> _performLogout(
    BuildContext mainContext,
    BuildContext dialogContext,
  ) async {
    try {
      await FirebaseAuth.instance.signOut();
      
      if (!mainContext.mounted) return;
      
      // Close dialog _handleLogout
      Navigator.pop(dialogContext);
      
      // Navigate to welcome page and clear stack (like when app is first opened)
      Navigator.pushAndRemoveUntil(
        mainContext,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
        (route) => false,
      );
    } catch (e) {
      // Handle error if for some reason logout fails
      if (!dialogContext.mounted) return;
      
      ScaffoldMessenger.of(mainContext).showSnackBar(
        const SnackBar(
          content: Text("Failed to log out. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}