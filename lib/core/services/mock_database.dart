import 'package:fast_ego_frontend/core/models/user.dart';

class MockDatabase {
  static final List<Map<String, dynamic>> _users = [];

  static const List<String> securityQuestions = [
    'What is your mother\'s maiden name?',
    'What was the name of your first pet?',
    'What is your favorite book?',
    'What city were you born in?',
    'What is your favorite movie?',
  ];

  static Future<void> addUser(
      User user,
      String password,
      String securityQuestion,
      String securityAnswer,
      ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _users.add({
      'id': user.id,
      'userName': user.userName,
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'token': user.token,
      'password': password,
      'securityQuestion': securityQuestion,
      'securityAnswer': securityAnswer,
    });
  }

  static Future<bool> isEmailUnique(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return !_users.any((user) => user['email'] == email);
  }

  static Future<bool> doesEmailExist(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _users.any((user) => user['email'] == email);
  }

  static Future<User?> getUserByEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final userData = _users.firstWhere((user) => user['email'] == email);
      return User(
        id: userData['id'] as String,
        userName: userData['userName'] as String,
        email: userData['email'] as String,
        firstName: userData['firstName'] as String,
        lastName: userData['lastName'] as String,
        token: userData['token'] as String,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<User?> getUserByUsername(String userName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final userData = _users.firstWhere((user) => user['userName'] == userName);
      return User(
        id: userData['id'] as String,
        userName: userData['userName'] as String,
        email: userData['email'] as String,
        firstName: userData['firstName'] as String,
        lastName: userData['lastName'] as String,
        token: userData['token'] as String,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<bool> validateLogin(String userName, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _users.any((user) => user['userName'] == userName && user['password'] == password);
  }

  static Future<bool> validateForgotPassword(String email, String answer) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final userData = _users.firstWhere((user) => user['email'] == email);
      return userData['securityAnswer'] == answer;
    } catch (e) {
      return false;
    }
  }

  static Future<void> updatePassword(String email, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final userData = _users.firstWhere((user) => user['email'] == email);
    final index = _users.indexOf(userData);
    _users[index] = {
      ...userData,
      'password': newPassword,
    };
  }
  static Future<String?> getSecurityQuestionForUser(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final userData = _users.firstWhere((user) => user['email'] == email);
      return userData['securityQuestion'] as String;
    } catch (e) {
      return null;
    }
  }
}