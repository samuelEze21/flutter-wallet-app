import 'package:flutter/foundation.dart';
import 'package:fast_ego_frontend/core/services/get_a_card_service.dart';

class GetACardProvider with ChangeNotifier {
  final GetACardService _getACardService = GetACardService();

  String? _cardId;
  String? _pin;
  String? _confirmPin;
  String? _errorMessage;
  String? _pinError;
  String? _confirmPinError;
  String? _cardIdError;
  bool _isLoading = false;

  String? get cardId => _cardId;
  String? get pin => _pin;
  String? get confirmPin => _confirmPin;
  String? get errorMessage => _errorMessage;
  String? get pinError => _pinError;
  String? get confirmPinError => _confirmPinError;
  String? get cardIdError => _cardIdError;
  bool get isLoading => _isLoading;

  void setCardId(String value) {
    _cardId = value;
    _cardIdError = null;
    if (value.isEmpty) {
      _cardIdError = 'Card ID is required';
    }
    notifyListeners();
  }

  void setPin(String value) {
    _pin = value;
    _pinError = null;
    if (value.length != 4) {
      _pinError = 'PIN must be 4 digits';
    }
    notifyListeners();
  }

  void setConfirmPin(String value) {
    _confirmPin = value;
    _confirmPinError = null;
    if (value != _pin) {
      _confirmPinError = 'PINs do not match';
    }
    notifyListeners();
  }

  Future<String?> generateVirtualAccount(String userId, String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _getACardService.generateVirtualAccount(userId, token);
    } catch (e) {
      _errorMessage = 'Failed to generate virtual account: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> makePaymentForCard(String userId, String token, double amount) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _getACardService.makePaymentForCard(userId, token, amount);
    } catch (e) {
      _errorMessage = 'Payment failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerCard(String userId, String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_cardId == null || _cardId!.isEmpty) {
      _cardIdError = 'Card ID is required';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (_pin == null || _pin!.length != 4) {
      _pinError = 'PIN must be 4 digits';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (_confirmPin != _pin) {
      _confirmPinError = 'PINs do not match';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      return await _getACardService.registerCard(userId, token, _cardId!, _pin!);
    } catch (e) {
      _errorMessage = 'Failed to register card: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _cardId = null;
    _pin = null;
    _confirmPin = null;
    _errorMessage = null;
    _pinError = null;
    _confirmPinError = null;
    _cardIdError = null;
    _isLoading = false;
    notifyListeners();
  }
}