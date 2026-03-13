import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tahir_showroom/app/features/auth/data/auth_service.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';

/// LoginController - Manages login form state and authentication flow
class LoginController extends GetxController {
  // Form controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Form key for validation
  final formKey = GlobalKey<FormState>();
  
  // Observable states
  final isLoading = false.obs;
  final keepMeLoggedIn = false.obs;
  final obscurePassword = true.obs;
  final errorMessage = RxnString();

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Toggle "Keep me logged in" checkbox
  void toggleKeepMeLoggedIn(bool? value) {
    keepMeLoggedIn.value = value ?? false;
  }

  /// Validate username
  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }

  /// Perform login
  Future<void> login() async {
    // Clear previous error
    errorMessage.value = null;
    
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final authService = Get.find<AuthService>();
      
      final result = await authService.login(
        username: usernameController.text,
        password: passwordController.text,
        keepLoggedIn: keepMeLoggedIn.value,
      );

      if (result.success) {
        // Navigate to Dashboard
        Get.offAllNamed('/dashboard');
      } else {
        errorMessage.value = result.errorMessage;
        // Show error notification dialog
        AppNotificationDialog.showError(
          title: 'Login Failed',
          message: result.errorMessage ?? 'Unknown error',
        );
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'An error occurred. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear form
  void clearForm() {
    usernameController.clear();
    passwordController.clear();
    keepMeLoggedIn.value = false;
    errorMessage.value = null;
  }
}

// Authored by: Moazzam Samoo
