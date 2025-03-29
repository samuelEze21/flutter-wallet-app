import 'package:flutter/material.dart';
import 'package:fast_ego_frontend/core/services/merchant_service.dart';

class MerchantProvider with ChangeNotifier {
  final MerchantService _service = MerchantService();

  String? _machineId;
  String? _cardId;
  String? _email;
  String? _machineIdError;
  String? _cardIdError;
  String? _emailError;
  bool _isLoading = false;
  String? _errorMessage;

  String? get machineId => _machineId;
  String? get cardId => _cardId;
  String? get email => _email;
  String? get machineIdError => _machineIdError;
  String? get cardIdError => _cardIdError;
  String? get emailError => _emailError;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setMachineId(String value) {
    _machineId = value;
    _machineIdError = value.isEmpty ? 'Machine ID is required' : null;
    notifyListeners();
  }

  void setCardId(String value) {
    _cardId = value;
    _cardIdError = value.isEmpty ? 'Card ID is required' : null;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    _emailError = value.isEmpty
        ? 'Email is required'
        : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)
        ? 'Enter a valid email'
        : null;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  bool validate() {
    setMachineId(_machineId ?? '');
    setCardId(_cardId ?? '');
    setEmail(_email ?? '');
    return _machineIdError == null && _cardIdError == null && _emailError == null;
  }

  Future<bool> registerMerchant(String userId, String token) async {
    setLoading(true);
    setErrorMessage(null);
    try {
      if (validate()) {
        final success = await _service.registerMerchant(
          userId: userId,
          token: token,
          machineId: _machineId!,
          cardId: _cardId!,
          email: _email!,
        );
        if (success) {
          print('Register successfully'); // Log success
        }
        return success;
      }
      return false;
    } catch (e) {
      setErrorMessage(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  void clear() {
    _machineId = null;
    _cardId = null;
    _email = null;
    _machineIdError = null;
    _cardIdError = null;
    _emailError = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}