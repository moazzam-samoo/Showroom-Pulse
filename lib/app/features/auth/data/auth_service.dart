import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tahir_showroom/app/data/models/user.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';

/// AuthService - Handles user authentication and session management
class AuthService extends GetxService {
  static const String _sessionKey = 'logged_in_user_id';
  static const String _keepLoggedInKey = 'keep_logged_in';

  late SharedPreferences _prefs;
  
  // Current logged-in user
  final Rx<User?> currentUser = Rx<User?>(null);
  
  // Observable for login state
  bool get isLoggedIn => currentUser.value != null;

  /// Initialize the AuthService
  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  /// Hash password using SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Check if there's a saved session (for "Keep me logged in")
  Future<bool> checkSavedSession() async {
    final keepLoggedIn = _prefs.getBool(_keepLoggedInKey) ?? false;
    if (!keepLoggedIn) return false;

    final userId = _prefs.getInt(_sessionKey);
    if (userId == null) return false;

    // Load user from database
    final isarService = Get.find<IsarService>();
    final user = await isarService.isar.users.get(userId);
    
    if (user != null && user.isActive) {
      currentUser.value = user;
      return true;
    }
    
    // Session invalid, clear it
    await clearSession();
    return false;
  }

  /// Login with username and password
  Future<LoginResult> login({
    required String username,
    required String password,
    required bool keepLoggedIn,
  }) async {
    if (username.trim().isEmpty) {
      return LoginResult.failure('Username is required');
    }
    
    if (password.isEmpty) {
      return LoginResult.failure('Password is required');
    }

    final isarService = Get.find<IsarService>();
    
    // Find user by username
    final user = await isarService.isar.users
        .filter()
        .usernameEqualTo(username.trim().toLowerCase())
        .findFirst();

    if (user == null) {
      return LoginResult.failure('User not found');
    }

    if (!user.isActive) {
      return LoginResult.failure('Account is deactivated');
    }

    // Verify password
    final hashedPassword = hashPassword(password);
    if (user.passwordHash != hashedPassword) {
      return LoginResult.failure('Invalid password');
    }

    // Update last login
    user.lastLogin = DateTime.now();
    await isarService.isar.writeTxn(() async {
      await isarService.isar.users.put(user);
    });

    // Save session if "Keep me logged in" is checked
    if (keepLoggedIn) {
      await _prefs.setInt(_sessionKey, user.id);
      await _prefs.setBool(_keepLoggedInKey, true);
    }

    currentUser.value = user;
    return LoginResult.success(user);
  }

  /// Logout current user
  Future<void> logout() async {
    currentUser.value = null;
    await clearSession();
  }

  /// Clear saved session
  Future<void> clearSession() async {
    await _prefs.remove(_sessionKey);
    await _prefs.setBool(_keepLoggedInKey, false);
  }

  /// Create a new user (for initial setup or admin)
  Future<User?> createUser({
    required String username,
    required String password,
    required String displayName,
  }) async {
    final isarService = Get.find<IsarService>();
    
    // Check if username exists
    final existing = await isarService.isar.users
        .filter()
        .usernameEqualTo(username.trim().toLowerCase())
        .findFirst();

    if (existing != null) {
      return null; // Username already exists
    }

    final user = User()
      ..username = username.trim().toLowerCase()
      ..passwordHash = hashPassword(password)
      ..displayName = displayName
      ..isActive = true
      ..dateCreated = DateTime.now();

    await isarService.isar.writeTxn(() async {
      await isarService.isar.users.put(user);
    });

    return user;
  }

  /// Update current user's credentials
  Future<bool> updateCredentials({String? newUsername, String? newPassword}) async {
    final user = currentUser.value;
    if (user == null) return false;

    final isarService = Get.find<IsarService>();
    
    await isarService.isar.writeTxn(() async {
      if (newUsername != null && newUsername.trim().isNotEmpty) {
        user.username = newUsername.trim().toLowerCase();
      }
      
      if (newPassword != null && newPassword.isNotEmpty) {
        user.passwordHash = hashPassword(newPassword);
      }
      
      await isarService.isar.users.put(user);
    });

    currentUser.refresh(); // Notify listeners
    return true;
  }

  /// Check if any users exist (for first-time setup)
  Future<bool> hasUsers() async {
    final isarService = Get.find<IsarService>();
    final count = await isarService.isar.users.count();
    return count > 0;
  }

  /// Create default admin user if no users exist. Returns true if created.
  Future<bool> ensureDefaultUser() async {
    final hasExisting = await hasUsers();
    if (!hasExisting) {
      await createUser(
        username: 'admin',
        password: 'admin123',
        displayName: 'Administrator',
      );
      return true;
    }
    return false;
  }
}

/// Result class for login attempts
class LoginResult {
  final bool success;
  final User? user;
  final String? errorMessage;

  LoginResult._({
    required this.success,
    this.user,
    this.errorMessage,
  });

  factory LoginResult.success(User user) => LoginResult._(
    success: true,
    user: user,
  );

  factory LoginResult.failure(String message) => LoginResult._(
    success: false,
    errorMessage: message,
  );
}

// Authored by: Moazzam Samoo
