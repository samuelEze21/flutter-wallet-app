import 'dart:convert';
import 'package:http/http.dart' as http;

class MerchantService {
  static final MerchantService _instance = MerchantService._internal();
  factory MerchantService() => _instance;
  MerchantService._internal();

  static const String _baseUrl = 'https://your-backend-api.com/api';
  static const bool _useMock = true; // Set to true to use mock, false to use backend

  // Mock data for merchant registration
  static final List<Map<String, dynamic>> _mockMerchants = [];

  // Register a merchant
  Future<bool> registerMerchant({
    required String userId,
    required String token,
    required String machineId,
    required String cardId,
    required String email,
  }) async {
    if (_useMock) {
      // Simulate a successful merchant registration
      await Future.delayed(const Duration(milliseconds: 500));
      final existingMerchant = _mockMerchants.any((merchant) => merchant['email'] == email);
      if (existingMerchant) {
        throw Exception('Merchant with this email already exists');
      }
      _mockMerchants.add({
        'userId': userId,
        'machineId': machineId,
        'cardId': cardId,
        'email': email,
        'status': 'registered',
      });
      return true;
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/merchant/register'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userId': userId,
            'machineId': machineId,
            'cardId': cardId,
            'email': email,
          }),
        );

        if (response.statusCode == 200) {
          return true;
        } else {
          final error = jsonDecode(response.body)['message'] ?? 'Merchant registration failed';
          throw Exception(error);
        }
      } catch (e) {
        throw Exception('Failed to register merchant: $e');
      }
    }
  }
}