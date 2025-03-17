import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wsm_mobile_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  // Services
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final AuthService _authService = AuthService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  // Setters

  // Initialize
  AuthProvider() {
    handleCheckAuth();
  }

  // Functions
  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Do anything
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<void> handleLogin(
      {required String username, required String password}) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> token =
          await _authService.login(username: username, password: password);
      await saveAuthData(token);
      await handleCheckAuth();
    } catch (e) {
      _error = "Invalid Credential.";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveAuthData(Map<String, dynamic> token) async {
    try {
      // Store token
      await _storage.write(key: 'token', value: token['token'] ?? '');

      // Store profile data
      final profile = token['profile'] as Map<String, dynamic>? ?? {};
      await _storage.write(key: 'avatar', value: profile['avatar'] ?? '');
      await _storage.write(key: 'name', value: profile['name'] ?? '');
      await _storage.write(key: 'username', value: profile['username'] ?? '');
      await _storage.write(key: 'email', value: profile['email'] ?? '');
      final defaultPos = profile['default_pos'] as Map<String, dynamic>? ?? {};
      await _storage.write(
        key: 'posId',
        value: defaultPos['id']?.toString() ?? '',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> handleLogout() async {
    _isLoggedIn = false;
    await _storage.delete(key: 'token');
    notifyListeners();
  }

  // Check Auth
  Future<void> handleCheckAuth() async {
    try {
      _isLoading = true;
      notifyListeners();
      String? token = await _storage.read(key: 'token');
      if (token == null || token.isEmpty) {
        _isLoggedIn = false;
      } else {
        _isLoggedIn = await _validateToken(token);
      }
    } catch (e) {
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _validateToken(String token) async {
    // Verrify token in here
    return token.isNotEmpty;
  }
}
