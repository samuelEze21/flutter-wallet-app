import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fast_ego_frontend/core/models/user.dart';
import 'package:fast_ego_frontend/core/services/mock_database.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _baseUrl = 'https://your-backend-api.com/api';
  static const bool _useMock = true; // Set to true to use MockDatabase, false to use backend

  Future<User> signup({
    required String userName,
    required String password,
    required String email,
    required String securityQuestion,
    required String securityAnswer,
    required String firstName,
    required String lastName,
  }) async {
    if (_useMock) {
      final isUnique = await MockDatabase.isEmailUnique(email);
      if (!isUnique) {
        throw Exception('Email is already in use');
      }

      final user = User(
        id: 'mock_${DateTime.now().millisecondsSinceEpoch}', // Generate mock ID
        userName: userName,
        email: email,
        firstName: firstName,
        lastName: lastName,
        token: 'mock_token_$userName', // Generate mock token
      );
      await MockDatabase.addUser(user, password, securityQuestion, securityAnswer);
      return user;
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/auth/signup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'userName': userName,
            'password': password,
            'email': email,
            'securityQuestion': securityQuestion,
            'securityAnswer': securityAnswer,
            'firstName': firstName,
            'lastName': lastName,
          }),
        );

        if (response.statusCode == 201) {
          return User.fromJson(jsonDecode(response.body));
        } else {
          final error = jsonDecode(response.body)['message'] ?? 'Signup failed';
          throw Exception(error);
        }
      } catch (e) {
        throw Exception('Failed to sign up: $e');
      }
    }
  }

  Future<User> login({
    required String userName,
    required String password,
  }) async {
    if (_useMock) {
      final success = await MockDatabase.validateLogin(userName, password);
      if (success) {
        final user = await MockDatabase.getUserByUsername(userName);
        if (user != null) {
          return user;
        }
      }
      throw Exception('Invalid username or password');
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'userName': userName,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          return User.fromJson(jsonDecode(response.body));
        } else {
          final error = jsonDecode(response.body)['message'] ?? 'Login failed';
          throw Exception(error);
        }
      } catch (e) {
        throw Exception('Failed to log in: $e');
      }
    }
  }

  Future<bool> forgotPassword(String email, String answer, String newPassword) async {
    if (_useMock) {
      final success = await MockDatabase.validateForgotPassword(email, answer);
      if (success) {
        await MockDatabase.updatePassword(email, newPassword);
        return true;
      }
      return false;
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/auth/forgot-password'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'securityAnswer': answer,
            'newPassword': newPassword,
          }),
        );

        if (response.statusCode == 200) {
          return true;
        } else {
          final error = jsonDecode(response.body)['message'] ?? 'Password reset failed';
          throw Exception(error);
        }
      } catch (e) {
        throw Exception('Failed to reset password: $e');
      }
    }
  }

  Future<bool> isEmailUnique(String email) async {
    if (_useMock) {
      return await MockDatabase.isEmailUnique(email);
    } else {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/auth/check-email?email=$email'),
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body)['isUnique'] as bool;
        } else {
          throw Exception('Failed to check email uniqueness');
        }
      } catch (e) {
        throw Exception('Failed to check email uniqueness: $e');
      }
    }
  }

  Future<bool> doesEmailExist(String email) async {
    if (_useMock) {
      return await MockDatabase.doesEmailExist(email);
    } else {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/auth/does-email-exist?email=$email'),
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body)['exists'] as bool;
        } else {
          throw Exception('Failed to check email existence');
        }
      } catch (e) {
        throw Exception('Failed to check email existence: $e');
      }
    }
  }

  Future<User?> getUserByEmail(String email) async {
    if (_useMock) {
      return await MockDatabase.getUserByEmail(email);
    } else {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/auth/user-by-email?email=$email'),
        );

        if (response.statusCode == 200) {
          return User.fromJson(jsonDecode(response.body));
        } else if (response.statusCode == 404) {
          return null;
        } else {
          throw Exception('Failed to fetch user by email');
        }
      } catch (e) {
        throw Exception('Failed to fetch user by email: $e');
      }
    }
  }

  Future<List<String>> getSecurityQuestions() async {
    if (_useMock) {
      return MockDatabase.securityQuestions;
    } else {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/auth/security-questions'),
        );

        if (response.statusCode == 200) {
          return List<String>.from(jsonDecode(response.body));
        } else {
          throw Exception('Failed to fetch security questions');
        }
      } catch (e) {
        throw Exception('Failed to fetch security questions: $e');
      }
    }
  }

  Future<String?> getSecurityQuestionForUser(String email) async {
    if (_useMock) {
      return await MockDatabase.getSecurityQuestionForUser(email);
    } else {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/auth/security-question?email=$email'),
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body)['securityQuestion'] as String;
        } else if (response.statusCode == 404) {
          return null;
        } else {
          throw Exception('Failed to fetch security question');
        }
      } catch (e) {
        throw Exception('Failed to fetch security question: $e');
      }
    }
  }
}