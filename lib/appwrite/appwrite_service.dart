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

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailPasswordSession(email: email, password: password);
      print('Login successful!');

      // Check if the session is valid
      final session = await _account.getSession(sessionId: 'current');
      print('Session ID: ${session.$id}');
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    }
  }

  /// Logout user
  Future<void> logoutUser() async {
    try {
      // Get the current session
      final session = await _account.getSession(sessionId: 'current');
      await _account.deleteSession(sessionId: session.$id);
      print('Logout successful!');
    } catch (e) {
      print('Logout Error: $e');
      rethrow;
    }
  }
}