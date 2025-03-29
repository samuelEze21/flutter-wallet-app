import 'package:flutter/material.dart';
import 'package:fast_ego_frontend/core/services/contact_service.dart';

class ContactProvider with ChangeNotifier {
  final ContactService _service = ContactService();

  String? _message;
  String? _messageError;
  bool _isLoading = false;
  String? _errorMessage;

  String? get message => _message;
  String? get messageError => _messageError;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setMessage(String value) {
    _message = value;
    _messageError = value.isEmpty ? 'Message is required' : null;
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
    setMessage(_message ?? '');
    return _messageError == null;
  }

  Future<bool> sendContactMessage(String userId, String token) async {
    setLoading(true);
    setErrorMessage(null);
    try {
      if (validate()) {
        final success = await _service.sendContactMessage(
          userId: userId,
          token: token,
          message: _message!,
        );
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
    _message = null;
    _messageError = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}