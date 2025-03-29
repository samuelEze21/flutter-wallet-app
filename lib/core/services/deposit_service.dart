import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fast_ego_frontend/core/services/balance_service.dart';

class DepositService {
  static final DepositService _instance = DepositService._internal();
  factory DepositService() => _instance;
  DepositService._internal();

  static const String _baseUrl = 'https://your-backend-api.com/api';
  static const bool _useMock = true; // Set to true to use mock, false to use backend

  final BalanceService _balanceService = BalanceService();

  // Mock data for deposits
  static final Map<String, dynamic> _mockDepositData = {};

  // Generate a virtual account number for the deposit
  Future<String> generateAccountNumber(String userId, String token) async {
    if (_useMock) {
      // Simulate generating a virtual account number (aligned with DepositProvider)
      await Future.delayed(const Duration(milliseconds: 500));
      return '1234567890'; // Same mock account number as in DepositProvider
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/deposit/generate-account'),
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
          return data['accountNumber'];
        } else {
          final error = jsonDecode(response.body)['message'] ?? 'Failed to generate account number';
          throw Exception(error);
        }
      } catch (e) {
        throw Exception('Failed to generate account number: $e');
      }
    }
  }

  // Confirm the deposit and update the balance
  Future<bool> confirmDeposit(String userId, String token, double amount, String accountNumber, String password) async {
    if (_useMock) {
      // Simulate confirming a deposit
      await Future.delayed(const Duration(milliseconds: 500));
      if (password != "correct_password") {
        throw Exception('Incorrect password');
      }

      // Update balance
      final currentBalance = await _balanceService.checkBalance(userId, token);
      await _balanceService.updateBalance(userId, token, currentBalance + amount);
      _mockDepositData[userId] = {
        'amount': amount,
        'accountNumber': accountNumber,
        'status': 'completed',
      };
      return true;
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/deposit/confirm'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userId': userId,
            'amount': amount,
            'accountNumber': accountNumber,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          final currentBalance = await _balanceService.checkBalance(userId, token);
          await _balanceService.updateBalance(userId, token, currentBalance + amount);
          return true;
        } else {
          final error = jsonDecode(response.body)['message'] ?? 'Deposit confirmation failed';
          throw Exception(error);
        }
      } catch (e) {
        throw Exception('Failed to confirm deposit: $e');
      }
    }
  }
}