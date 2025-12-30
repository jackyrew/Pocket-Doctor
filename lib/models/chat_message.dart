class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final String? type; // 'greeting', 'diagnosis', 'follow_up', etc.

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.type,
  });
}
