import 'package:flutter/material.dart';

class HomeNewUser extends StatelessWidget {
  final String userName; // pass "Abu" etc.

  const HomeNewUser({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF3E7AEB); // #3E7AEB
    const lightBlue = Color(0xFFE9F3FF); // #E9F3FF

    final firstName = userName.split(' ').first;

    return Scaffold(
      backgroundColor: Colors.white, // FFFFFF
      body: SafeArea(
        child: Column(
          children: [
            // MAIN SCROLL AREA
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // TOP ROW: Logo + "Pocket Doctor" + user avatar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/bear-logo.png',
                              height: 32,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Pocket Doctor',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: const AssetImage(
                            'assets/icons/User-image.png',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // GREETING "Hello, Abu"
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/hands-emoji.png',
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, $firstName',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'How can I help you today?',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF858585),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // BIG "Check Symptoms" BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          //go to symptom checker
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/Messages.png',
                              height: 22,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Check Symptoms',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // "Explore more" TITLE
                    const Text(
                      'Explore more',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // CLOCK CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/clock.png',
                            height: 64,
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              "Need a nudge? Let us\nremind you when it’s time\nto take your medicine.",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // "Add Medicine Timer" small button inside card area
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          //go to add timer
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: primaryBlue),
                          ),
                        ),
                        child: const Text(
                          'Add Medicine Timer',
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // "Add a Reminder" TITLE
                    const Text(
                      'Add a Reminder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // BIG BLUE "Add a medicine timer" ROW
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/pills-image.png',
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Add a medicine timer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // "Tips of the day" CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tips of the day',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '• Take meds at the same time each day for best effect.\n'
                            '• Don’t skip your dose — set a reminder if needed.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // BOTTOM NAV
            const _BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/icons/Home-button.png', height: 26),
          Image.asset('assets/icons/Clock-button.png', height: 26),
          Image.asset('assets/icons/Chat-button.png', height: 26),
          Image.asset('assets/icons/Profile-button.png', height: 26),
        ],
      ),
    );
  }
}
