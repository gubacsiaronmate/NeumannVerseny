import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';

class AppwriteService {
  final Client _client = Client();
  late final Account _account;

  AppwriteService() {
    _initializeClient();
  }

  void _initializeClient() {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('678aa790002d7c50d1a8');
    _account = Account(_client);
  }

  /// Register a new user
  Future<void> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await _account.create(
        name: username,
        email: email,
        password: password,
        userId: ID.unique(),
      );
      print('Registration successful!');
    } catch (e) {
      print('Registration Error: $e');
      rethrow;
    }
  }

  String? _currentSessionId;

  /// Log in an existing user
  Future<void> loginUser({
    required String email,
    required String secret,
    required String userId,
  }) async {
    try {
      final session = await _account.createEmailPasswordSession(
        email: email,
        password: secret,
      );
      _currentSessionId = session.$id;
      print('Login successful: ${session.userId}');
    } on AppwriteException catch (e) { // Use 'on' for specific exception types
      if (e.code == 401) {
        print('Invalid credentials.');
      } else if (e.code == 404) {
        print('Account does not exist.');
      } else {
        print('Login failed: $e');
      }
    } catch (e) { // General catch block for other exceptions
      print('Login failed: $e');
    }
  }


  /// Log out the current user
  Future<void> logoutUser() async {
    try {
      if (_currentSessionId != null) {
        await _account.deleteSession(sessionId: _currentSessionId!);
        print('Logout successful!');
        _currentSessionId = null;
      } else {
        print('No session ID available for logout.');
      }
    } catch (e) {
      print('Logout Error: $e');
      rethrow;
    }
  }


  /// Get current user details
  Future<void> getUser() async {
    try {
      final user = await _account.get();
      print('User: ${user.name}');
    } catch (e) {
      print('Get User Error: $e');
      rethrow;
    }
  }
}
