import 'package:flutter/material.dart';
import 'package:pocket_doctor/chat/widgets/message_bubble.dart';
import 'package:pocket_doctor/models/chat_message.dart';
import 'package:pocket_doctor/services/api_service.dart';
import 'package:pocket_doctor/services/auth_service.dart';

class ChatbotScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ChatbotScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _apiService = ApiService();

  final List<ChatMessage> _messages = [];
  bool _isBotTyping = false;

  // Session data
  int? _sessionId;
  int? _userAge;
  String? _userSex;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data first
    // Add welcome message
    _messages.add(
      ChatMessage(
        text: "Hello! I'm Pocket Doctor. How can I help you today?",
        isUser: false,
        time: DateTime.now(),
        type: 'greeting',
      ),
    );
  }

  // Load user age and gender from Firebase
  Future<void> _loadUserData() async {
    try {
      final authService = AuthService();
      final userData = await authService.getUserData(widget.userId);

      if (userData != null) {
        setState(() {
          _userAge = int.tryParse(userData['age'].toString());
          // Convert "Male"/"Female"/"Other" to "male"/"female"/"other"
          _userSex = userData['gender']?.toString().toLowerCase();
        });
        print("Loaded user data - Age: $_userAge, Sex: $_userSex");
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    final userMsg = ChatMessage(
      text: text,
      isUser: true,
      time: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isBotTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Call Laravel API
      final response = await _apiService.sendMessage(
        userId: widget.userId,
        message: text,
        age: _userAge,
        sex: _userSex,
        sessionId: _sessionId,
      );

      // Save session ID
      _sessionId = response.sessionId;

      // Add bot response
      setState(() {
        _messages.add(
          ChatMessage(
            text: response.reply,
            isUser: false,
            time: DateTime.now(),
            type: response.type,
          ),
        );
        _isBotTyping = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                "Sorry, I'm having trouble connecting. Please try again.\n\nError: $e",
            isUser: false,
            time: DateTime.now(),
            type: 'error',
          ),
        );
        _isBotTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Column(
        children: [
          _buildHeader(context),
          _buildDisclaimer(),
          const SizedBox(height: 8),
          Expanded(child: _buildMessagesList()),
          if (_isBotTyping) _buildTypingIndicator(),
          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 8,
        right: 8,
        bottom: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                    'assets/images/pocket_doctor_logo.png',
                  ),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pocket Doctor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF4F6F8),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      child: Text(
        'Disclaimer: Pocket Doctor AI provides general information only and is not a substitute for a real doctor.',
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return MessageBubble(message: msg);
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.4, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted) setState(() {});
      },
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 10,
          top: 4,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _messageController,
                  enabled: !_isBotTyping,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write a Message..',
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _isBotTyping ? null : _sendMessage,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _isBotTyping ? Colors.grey : const Color(0xFF2962FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
