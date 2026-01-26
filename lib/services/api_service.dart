import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 🔥 CHANGE THIS TO YOUR LARAVEL API URL
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:8000/api'; // iOS simulator
  // static const String baseUrl = 'https://your-domain.com/api'; // Production

  /// Send a chat message to Laravel backend
  Future<ChatResponse> sendMessage({
    required String userId,
    required String message,
    int? age,
    String? sex,
    int? sessionId,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/chat'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'user_id': userId,
              'message': message,
              if (age != null) 'age': age,
              if (sex != null) 'sex': sex,
              if (sessionId != null) 'session_id': sessionId,
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timed out. Please try again.');
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatResponse.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['reply'] ?? 'Failed to get response');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}

/// Response model from Laravel backend
class ChatResponse {
  final int sessionId;
  final String
  type; // 'greeting', 'need_demographics', 'follow_up_question', 'diagnosis', 'error'
  final String reply;
  final Map<String, dynamic>? debug;

  ChatResponse({
    required this.sessionId,
    required this.type,
    required this.reply,
    this.debug,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      sessionId: json['session_id'] as int,
      type: json['type'] as String,
      reply: json['reply'] as String,
      debug: json['debug'] as Map<String, dynamic>?,
    );
  }

  bool get needsDemographics => type == 'need_demographics';
  bool get isFollowUpQuestion => type == 'follow_up_question';
  bool get isDiagnosis => type == 'diagnosis';
  bool get isGreeting => type == 'greeting';
  bool get isError => type == 'error';
}
