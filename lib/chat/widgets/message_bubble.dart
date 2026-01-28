import 'package:flutter/material.dart';
import 'package:pocket_doctor/models/chat_message.dart';

/// Message Bubble Widget
///
/// ACADEMIC CITATION:
/// Enhanced with guidance from Claude AI (Anthropic, 2025) for improved
/// diagnosis message styling and user experience.
///
/// Reference:
/// Anthropic. (2025). Claude AI [Large Language Model]. https://www.anthropic.com
class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = isUser ? Colors.white : const Color(0xFFE3F2FD);
    final textColor = Colors.black87;

    // Separate styling for different message types
    final isDiagnosis = message.type == 'diagnosis';
    final isError = message.type == 'error';
    final isFollowUp = message.type == 'follow_up_question';

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isError
              ? const Color(0xFFFFEBEE) // Light red for errors
              : bubbleColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
          // Special borders for special message types
          border: isDiagnosis
              ? Border.all(color: const Color(0xFF2962FF), width: 1.5)
              : isError
              ? Border.all(color: Colors.red.shade300, width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show icon and label for special message types
            if (!isUser && (isDiagnosis || isError || isFollowUp))
              _buildMessageTypeHeader(isDiagnosis, isError, isFollowUp),

            // Message text
            Text(
              message.text,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                height: 1.4,
              ),
            ),

            // Timestamp
            const SizedBox(height: 4),
            Text(
              _formatTime(message.time),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTypeHeader(
    bool isDiagnosis,
    bool isError,
    bool isFollowUp,
  ) {
    IconData icon;
    String label;
    Color color;

    if (isDiagnosis) {
      icon = Icons.medical_services_outlined;
      label = 'Diagnosis Summary';
      color = const Color(0xFF2962FF);
    } else if (isError) {
      icon = Icons.error_outline;
      label = 'Error';
      color = Colors.red.shade700;
    } else if (isFollowUp) {
      icon = Icons.question_answer_outlined;
      label = 'Follow-up Question';
      color = const Color(0xFF2962FF);
    } else {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Feature added based on Claude AI's suggestion.
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
