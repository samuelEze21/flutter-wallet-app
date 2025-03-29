import 'package:flutter/foundation.dart';
import 'package:fast_ego_frontend/core/services/deposit_service.dart';

class DepositProvider with ChangeNotifier {
  final DepositService _depositService = DepositService();

  String? _amount;
  String? _accountNumber;
  bool _isLoading = false;
  String? _errorMessage;
  String? _amountError;

  String? get amount => _amount;
  String? get accountNumber => _accountNumber;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get amountError => _amountError;

  void setAmount(String value) {
    _amount = value;
    if (value.isEmpty) {
      _amountError = 'Amount cannot be empty';
    } else if (double.tryParse(value) == null || double.parse(value) <= 0) {
      _amountError = 'Enter a valid amount';
    } else {
      _amountError = null;
    }
    notifyListeners();
  }

  Future<void> generateAccountNumber(String userId, String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _accountNumber = await _depositService.generateAccountNumber(userId, token);
    } catch (e) {
      _errorMessage = 'Failed to generate account number: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool validateAmount() {
    return _amount != null && _amountError == null;
  }

  Future<bool> confirmDeposit(String userId, String token, double amount, String accountNumber, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      return await _depositService.confirmDeposit(userId, token, amount, accountNumber, password);
    } catch (e) {
      _errorMessage = 'Deposit error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}