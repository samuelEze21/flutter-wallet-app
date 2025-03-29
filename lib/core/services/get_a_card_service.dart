import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fast_ego_frontend/core/services/balance_service.dart';

class GetACardService {
  static final GetACardService _instance = GetACardService._internal();
  factory GetACardService() => _instance;
  GetACardService._internal();

  static const String _baseUrl = 'https://your-backend-api.com/api';
  static const bool _useMock = true; // Set to true to use mock, false to use backend

  final BalanceService _balanceService = BalanceService();

  // Mock data for card payment and registration
  static final Map<String, dynamic> _mockCardData = {};

  // Generate a virtual account number for payment
  Future<String> generateVirtualAccount(String userId, String token) async {
    if (_useMock) {
      // Simulate generating a virtual account number (aligned with DepositService)
      await Future.delayed(const Duration(milliseconds: 500));
      return '1234567890'; // Same mock account number as in DepositService
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/card/generate-virtual-account'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userId': userId,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['virtualAccount'];
        } else {
          final error = jsonDecode(response.body)['message'] ?? 'Failed to generate virtual account';
          throw Exception(error);
        }
      } catch (e) {
        throw Exception('Failed to generate virtual account: $e');
      }
    }
  }

  // Make payment for the card (debit 1 SUI)
  Future<bool> makePaymentForCard(String userId, String token, double amount) async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (_mockCardData.containsKey(userId)) {
        throw Exception('Card payment already processed for this user');
      }

      double currentBalance = await _balanceService.checkBalance(userId, token);
      if (currentBalance < amount) {
        throw Exception('Insufficient balance');
      }

      await _balanceService.updateBalance(userId, token, currentBalance - amount);
      _mockCardData[userId] = {'paymentStatus': 'pending', 'amount': amount};
      return true;
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/card/make-payment'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userId': userId,
            'amount': amount,
          }),
        );

        if (response.statusCode == 200) {
          double currentBalance = await _balanceService.checkBalance(userId, token);
          await _balanceService.updateBalance(userId, token, currentBalance - amount);
          return true;
        } else {
          final error = jsonDecode(response.body)['message'] ?? 'Payment failed';
          throw Exception(error);
        }
      } catch (e) {
        throw Exception('Failed to make payment: $e');
      }
    }
  }

  // Register the card with a PIN and cardId
  Future<bool> registerCard(String userId, String token, String cardId, String pin) async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!_mockCardData.containsKey(userId)) {
        throw Exception('Payment not made for this user');
      }
      _mockCardData[userId] = {
        ..._mockCardData[userId],
        'cardId': cardId,
        'pin': pin,
        'registrationStatus': 'completed',
      };
      return true;
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/card/register'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userId': userId,
            'cardId': cardId,
            'pin': pin,
          }),
        );

        if (response.statusCode == 200) {
          return true;
        } else {
          final error = jsonDecode(response.body)['message'] ?? 'Card registration failed';
          throw Exception(error);
        }
      } catch (e) {
        throw Exception('Failed to register card: $e');
      }
    }
  }
}