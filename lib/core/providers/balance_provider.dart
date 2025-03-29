import 'package:flutter/material.dart';
import '../services/balance_service.dart';

class BalanceProvider with ChangeNotifier {
  final BalanceService _balanceService = BalanceService();
  double _balance = 0.0;
  bool _isLoading = false;
  String? _errorMessage;

  double get balance => _balance;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBalance(String userId, String token) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _balance = await _balanceService.checkBalance(userId, token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> deductBalance(String userId, String token, double amount) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final newBalance = _balance - amount;
      if (newBalance < 0) {
        _isLoading = false;
        _errorMessage = 'Insufficient balance';
        notifyListeners();
        return false;
      }

      final success = await _balanceService.updateBalance(userId, token, newBalance);
      if (success) {
        _balance = newBalance;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = 'Failed to update balance';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }


  void updateBalance(String userId, String token, double newBalance) {
    _balance = newBalance;
    notifyListeners();
  }
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}