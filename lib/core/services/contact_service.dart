import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactService {
  static final ContactService _instance = ContactService._internal();
  factory ContactService() => _instance;
  ContactService._internal();

  static const String _baseUrl = 'https://your-backend-api.com/api';
  static const bool _useMock = true; // Set to true to use mock, false to use backend

  // Send contact message
  Future<bool> sendContactMessage({
    required String userId,
    required String token,
    required String message,
  }) async {
    if (_useMock) {
      // Simulate sending a contact message
      await Future.delayed(const Duration(milliseconds: 500));
      return true; // Mock success
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/contact/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userId': userId,
            'message': message,
          }),
        );

        if (response.statusCode == 200) {
          return true;
        } else {
          final error = jsonDecode(response.body)['message'] ?? 'Failed to send message';
          throw Exception(error);
        }
      } catch (e) {
        throw Exception('Failed to send message: $e');
      }
    }
  }
}