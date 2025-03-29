import 'package:flutter/material.dart';
import 'package:fast_ego_frontend/core/models/user.dart';
import 'package:fast_ego_frontend/core/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _userId; // Added for user ID
  String? _userName;
  String? _password;
  String? _confirmPassword;
  String? _email;
  String? _securityQuestion;
  String? _securityAnswer;
  String? _firstName;
  String? _lastName;
  String? _token;

  String? _userNameError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _emailError;
  String? _securityAnswerError;
  String? _firstNameError;
  String? _lastNameError;

  bool _isLoading = false;
  String? _errorMessage;

  String? get userId => _userId; // Added getter for userId
  String? get userName => _userName;
  String? get password => _password;
  String? get confirmPassword => _confirmPassword;
  String? get email => _email;
  String? get securityQuestion => _securityQuestion;
  String? get securityAnswer => _securityAnswer;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get token => _token;

  String? get userNameError => _userNameError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  String? get emailError => _emailError;
  String? get securityAnswerError => _securityAnswerError;
  String? get firstNameError => _firstNameError;
  String? get lastNameError => _lastNameError;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setUserName(String value) {
    _userName = value;
    _userNameError = value.isEmpty ? 'Username is required' : null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _passwordError = value.isEmpty
        ? 'Password is required'
        : value.length < 6
        ? 'Password must be at least 6 characters'
        : null;
    if (_confirmPassword != null) {
      setConfirmPassword(_confirmPassword!);
    }
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _confirmPasswordError = value.isEmpty
        ? 'Confirm password is required'
        : value != _password
        ? 'Passwords do not match'
        : null;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    _emailError = value.isEmpty
        ? 'Email is required'
        : !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
        ? 'Enter a valid email'
        : null;
    notifyListeners();
  }

  void setSecurityQuestion(String value) {
    _securityQuestion = value;
    notifyListeners();
  }

  void setSecurityAnswer(String value) {
    _securityAnswer = value;
    _securityAnswerError = value.isEmpty ? 'Answer is required' : null;
    notifyListeners();
  }

  void setFirstName(String value) {
    _firstName = value;
    _firstNameError = value.isEmpty ? 'First name is required' : null;
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value;
    _lastNameError = value.isEmpty ? 'Last name is required' : null;
    notifyListeners();
  }

  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }

  void setUserId(String? userId) {
    _userId = userId;
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

  bool validateStep1() {
    setFirstName(_firstName ?? '');
    setLastName(_lastName ?? '');
    setUserName(_userName ?? '');
    return _firstNameError == null && _lastNameError == null && _userNameError == null;
  }

  bool validateStep2() {
    setPassword(_password ?? '');
    setConfirmPassword(_confirmPassword ?? '');
    return _passwordError == null && _confirmPasswordError == null;
  }

  Future<bool> validateStep3() async {
    setEmail(_email ?? '');
    setSecurityAnswer(_securityAnswer ?? '');

    if (_emailError == null) {
      try {
        final isUnique = await _authService.isEmailUnique(_email!);
        if (!isUnique) {
          _emailError = 'Email is already in use';
        }
      } catch (e) {
        _emailError = 'Failed to check email: $e';
      }
    }

    return _emailError == null && _securityAnswerError == null;
  }

  bool validateLogin() {
    setUserName(_userName ?? '');
    setPassword(_password ?? '');
    return _userNameError == null && _passwordError == null;
  }

  Future<bool> validateForgotPassword() async {
    setEmail(_email ?? '');
    setSecurityAnswer(_securityAnswer ?? '');

    if (_emailError == null) {
      try {
        final exists = await _authService.doesEmailExist(_email!);
        if (!exists) {
          _emailError = 'Email does not exist';
        }
      } catch (e) {
        _emailError = 'Failed to check email: $e';
      }
    }

    return _emailError == null && _securityAnswerError == null;
  }

  void clear() {
    _userId = null; // Clear userId
    _userName = null;
    _password = null;
    _confirmPassword = null;
    _email = null;
    _securityQuestion = null;
    _securityAnswer = null;
    _firstName = null;
    _lastName = null;
    _token = null;
    _userNameError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _emailError = null;
    _securityAnswerError = null;
    _firstNameError = null;
    _lastNameError = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<User?> signup() async {
    setLoading(true);
    setErrorMessage(null);
    try {
      final user = await _authService.signup(
        userName: _userName!,
        password: _password!,
        email: _email!,
        securityQuestion: _securityQuestion!,
        securityAnswer: _securityAnswer!,
        firstName: _firstName!,
        lastName: _lastName!,
      );
      setUserId(user.id); // Set userId from User model
      setToken(user.token);
      setFirstName(user.firstName);
      setLastName(user.lastName);
      return user;
    } catch (e) {
      setErrorMessage(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<User?> login() async {
    setLoading(true);
    setErrorMessage(null);
    try {
      if (validateLogin()) {
        final user = await _authService.login(
          userName: _userName!,
          password: _password!,
        );
        setUserId(user.id); // Set userId from User model
        setToken(user.token);
        setFirstName(user.firstName);
        setLastName(user.lastName);
        return user;
      }
      return null;
    } catch (e) {
      setErrorMessage(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> forgotPassword(String email, String answer, String newPassword) async {
    setLoading(true);
    setErrorMessage(null);
    try {
      final isValid = await validateForgotPassword();
      if (isValid) {
        return await _authService.forgotPassword(email, answer, newPassword);
      }
      return false;
    } catch (e) {
      setErrorMessage(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }
}