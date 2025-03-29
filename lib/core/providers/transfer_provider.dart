import 'package:flutter/material.dart';
import 'package:fast_ego_frontend/core/services/balance_service.dart';

class TransferProvider with ChangeNotifier {
  final BalanceService _balanceService = BalanceService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> confirmTransfer(String userId, String token, double amount, String walletAddress, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Mock backend call (replace with real API)
      await Future.delayed(const Duration(seconds: 1));
      if (password != "correct_password") { // Mock password check
        _isLoading = false;
        _errorMessage = 'Incorrect password';
        notifyListeners();
        return false;
      }

      final currentBalance = await _balanceService.checkBalance(userId, token);
      if (currentBalance < amount) {
        _isLoading = false;
        _errorMessage = 'Insufficient balance';
        notifyListeners();
        return false;
      }

      await _balanceService.updateBalance(userId, token, currentBalance - amount);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Transfer error: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}