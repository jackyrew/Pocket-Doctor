import 'dart:convert';
import 'package:http/http.dart' as http;

/// API Service for Pocket Doctor
///
/// Communicates with Laravel backend using OpenAI-based diagnosis system
///
/// ACADEMIC CITATION:
/// Updated with guidance from Claude AI (Anthropic, 2025) for better
/// error handling and response parsing.
///
/// Reference:
/// Anthropic. (2025). Claude AI [Large Language Model]. https://www.anthropic.com
class ApiService {
  // 🔥 CHANGE THIS TO YOUR LARAVEL API URL
  static const String _androidEmulatorUrl = 'http://10.0.2.2:8000/api';
  static const String _androidPhysicalUrl =
      'http://172.20.10.3:8000/api'; //physical android

  //Set the environment here
  static const String _environment = 'android_physical';

  static String get baseUrl {
    switch (_environment) {
      case 'android_emulator':
        return _androidEmulatorUrl;
      case 'android_physical':
        return _androidPhysicalUrl;
      default:
        return _androidEmulatorUrl;
    }
  }

  /// Send a chat message to Laravel backend
  Future<ChatResponse> sendMessage({
    required String userId,
    required String message,
    int? age,
    String? sex,
    int? sessionId,
  }) async {
    try {
      print('📤 Sending message to: $baseUrl/chat');
      print('   User: $userId');
      print('   Message: $message');
      print('   Session: $sessionId');

      final response = await http
          .post(
            Uri.parse('$baseUrl/chat'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'user_id': userId,
              'message': message,
              if (age != null) 'age': age, // Use actual age parameter
              if (sex != null) 'sex': sex, // Use actual sex parameter
              if (sessionId != null) 'session_id': sessionId,
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timed out. Please try again.');
            },
          );
      //Error handling based on status code, Reference by Claude AI.
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatResponse.fromJson(data);
      } else if (response.statusCode == 422) {
        // Validation error
        final error = jsonDecode(response.body);
        final errors = error['errors'] as Map<String, dynamic>?;
        final firstError = errors?.values.first;
        final errorMessage = firstError is List
            ? firstError.first
            : 'Validation error';
        throw Exception(errorMessage);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
          error['reply'] ?? error['message'] ?? 'Failed to get response',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception(
        'Network error: Cannot connect to server. Check your internet connection.',
      );
    } on FormatException catch (e) {
      throw Exception('Server error: Invalid response format.');
    } catch (e) {
      // Re-throw if already an Exception with a message
      if (e is Exception) rethrow;
      throw Exception('Connection error: $e');
    }
  }
}

// Response model from Laravel backend
class ChatResponse {
  final int sessionId;
  final String type;
  // Types: 'greeting', 'need_demographics', 'follow_up_question',
  //        'diagnosis', 'clarification', 'need_more_info', 'error'
  final String reply;
  final List<ChatOption>? options; // For displaying question options
  final Map<String, dynamic>? debug;

  ChatResponse({
    required this.sessionId,
    required this.type,
    required this.reply,
    this.options,
    this.debug,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    // Parse options if present
    List<ChatOption>? options;
    if (json['options'] != null && json['options'] is List) {
      options = (json['options'] as List)
          .map((opt) => ChatOption.fromJson(opt as Map<String, dynamic>))
          .toList();
    }

    return ChatResponse(
      sessionId: json['session_id'] as int,
      type: json['type'] as String,
      reply: json['reply'] as String,
      options: options,
      debug: json['debug'] as Map<String, dynamic>?,
    );
  }

  // Convenience getters
  bool get needsDemographics => type == 'need_demographics';
  bool get isFollowUpQuestion => type == 'follow_up_question';
  bool get isDiagnosis => type == 'diagnosis';
  bool get isGreeting => type == 'greeting';
  bool get isError => type == 'error';
  bool get needsClarification => type == 'clarification';
  bool get needsMoreInfo => type == 'need_more_info';
  bool get hasOptions => options != null && options!.isNotEmpty;
}

//Model for question options
class ChatOption {
  final int index;
  final String label;

  ChatOption({
    required this.index,
    required this.label,
  });

  factory ChatOption.fromJson(Map<String, dynamic> json) {
    return ChatOption(
      index: json['index'] as int,
      label: json['label'] as String,
    );
  }
}
