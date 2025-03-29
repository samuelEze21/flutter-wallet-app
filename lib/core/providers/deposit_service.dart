import 'dart:convert';
import 'package:http/http.dart' as http;

class DepositService {
  static final DepositService _instance = DepositService._internal();
  factory DepositService() => _instance;
  DepositService._internal();

  static const String _baseUrl = 'https://your-backend-api.com/api';
  static const bool _useMock = true;

  Future<String> generateAccountNumber(String userId, String token) async {
    if (_useMock) {

      await Future.delayed(const Duration(milliseconds: 500));
      return 'ACC${DateTime.now().millisecondsSinceEpoch}'; // Mock account number
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/deposit/generate-account-number'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userId': userId,
          }),
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body)['accountNumber'] as String;
        } else {
          final error = jsonDecode(response.body)['message'] ?? 'Failed to generate account number';
          throw Exception(error);
        }
      } catch (e) {
        throw Exception('Failed to generate account number: $e');
      }
    }
  }
}