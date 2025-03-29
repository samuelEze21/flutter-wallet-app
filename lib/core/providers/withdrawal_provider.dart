import 'package:flutter/material.dart';
import 'package:fast_ego_frontend/core/services/balance_service.dart';
import 'package:fast_ego_frontend/core/services/withdrawal_service.dart';

class WithdrawalProvider with ChangeNotifier {
  final BalanceService _balanceService = BalanceService();
  final WithdrawalService _withdrawalService = WithdrawalService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> withdraw(String userId, String token, double amount, String accountNumber, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final currentBalance = await _balanceService.checkBalance(userId, token);
      if (currentBalance < amount) {
        _isLoading = false;
        _errorMessage = 'Insufficient balance';
        notifyListeners();
        return;
      }

      final result = await _withdrawalService.withdrawFunds(
        userId: userId,
        token: token,
        amount: amount,
        accountNumber: accountNumber,
        password: password,
      );

      if (result['success']) {
        await _balanceService.updateBalance(userId, token, currentBalance - amount);
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _errorMessage = result['message'];
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Withdrawal error: $e';
      notifyListeners();
    }
  }

  Future<bool> confirmWithdrawal(String userId, String token, double amount, String accountNumber, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final currentBalance = await _balanceService.checkBalance(userId, token);
      if (currentBalance < amount) {
        _isLoading = false;
        _errorMessage = 'Insufficient balance';
        notifyListeners();
        return false;
      }

      final result = await _withdrawalService.withdrawFunds(
        userId: userId,
        token: token,
        amount: amount,
        accountNumber: accountNumber,
        password: password,
      );

      if (result['success']) {
        await _balanceService.updateBalance(userId, token, currentBalance - amount);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Withdrawal error: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}