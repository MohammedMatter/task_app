import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/core/services/network_manager.dart';
import 'package:task_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_app/features/home/domain/repositories/task_repository.dart';
import 'package:task_app/features/home/presentation/view_models/category_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/filter_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/notification_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/search_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/theme_view_model.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;

  final NetworkManager networkManager;
  bool hasError = false;
  AuthRepository authRepository;
  TaskRepository taskRepository;
  final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp passwordRegExp = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*])[A-Za-z\d!@#\$%^&*]{8,}$');

  AuthViewModel({
    required this.networkManager,
    required this.taskRepository,
    required this.authRepository,
  });

  Future signIn(String email, String password) async {
    try {
      hasError = false;
      isLoading = true;
      notifyListeners();

      final connected = await networkManager.hasInternetConnection();

      if (!connected) {
        isLoading = false;
        notifyListeners();
        return 'no-internet';
      }

      final result = await authRepository.signIn(email, password);
      isLoading = false;
      notifyListeners();
      return result;
    } on FirebaseAuthException catch (e) {
      hasError = true;
      isLoading = false;

      if (e.code == 'network-request-failed') {
        notifyListeners();
        return 'no-internet';
      }

      if (e.code == 'invalid-credential' ||
          e.code == 'user-not-found' ||
          e.code == 'wrong-password') {
        log(' Auth Error: ${e.code}');
        return null;
      }

      log('⚠️ FirebaseAuthException: ${e.code}');
    } catch (e) {
      log(' Unknown Error: $e');
      hasError = true;
      isLoading = false;
    }

    notifyListeners();
  }

 Future signUp(String email, String password, String name) async {
  try {
    hasError = false;
    isLoading = true;
    notifyListeners();

    final connected = await networkManager.hasInternetConnection();
    if (!connected) { 
      isLoading = false;
      notifyListeners();
      return 'no-internet';
    }

    final result = await authRepository.signUp(email, password, name);

    isLoading = false;
    notifyListeners();

    return result;
  } on FirebaseAuthException catch (e) {
    isLoading = false;

    if (e.code == 'email-already-in-use') {
      hasError = true;
      notifyListeners();
      return null;
    }

    if (e.code == 'network-request-failed') {
      notifyListeners();
      return 'no-internet';
    }
  } catch (e) {
    debugPrint('⚠️ Unknown error: $e');
    isLoading = false;
    hasError = true;
    notifyListeners();
  }

  notifyListeners();
}


  Future<void> clearAppCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
        log('✅ Cache cleared successfully!');
      }
    } catch (e) {
      print('Failed to clear cache: $e');
    }
  }

  Future signInWithGoogle() async {
    await authRepository.signInWithGoogle();
  }

  Future signOut(BuildContext context) async {
    try {
      await clearAppCache();
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.clear();
      isLoading = false;
      hasError = false;
      await authRepository.signOut();
      await authRepository.signOutWithGoogle();
      Provider.of<CategoryViewModel>(context, listen: false).reset();
      Provider.of<TaskViewModel>(context, listen: false).reset();
      Provider.of<ThemeViewModel>(context, listen: false).reset();
      Provider.of<FilterViewModel>(context, listen: false).reset();
      Provider.of<SearchViewModel>(context, listen: false).reset();
      Provider.of<NotificationViewModel>(context, listen: false).reset();
    } catch (e) {}
    notifyListeners();
  }

  Future signUpASGuest() async {
    try {
      await authRepository.signInAsGuest();
    } on Exception catch (e) {
      log('$e');
    }
    notifyListeners();
  }

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'email is required';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'invalid email';
    }

    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'field is required';
    } else if (!passwordRegExp.hasMatch(password)) {
      return 'Password must be at least 8 characters, include upper, lower, number & special character';
    }

    return null;
  }

  String? validateCurrentUpdatePassword(String value, currentPassword) {
    if (value.isEmpty) {
      return 'field is required';
    } else if (currentPassword != value) {
      return 'password incorrect';
    }
    return null;
  }

  String? validateUpdateConfirmdassword(
      String confirmdPassword, String newPassword) {
    if (confirmdPassword.isEmpty) {
      return 'field is empty';
    } else if (confirmdPassword != newPassword) {
      return 'Password does not match';
    }
    return null;
  }

  Future updatePassword(String newPassword, String oldPassword) async {
    await authRepository.updatePassword(newPassword, oldPassword);
    notifyListeners();
    await Future.delayed(
      const Duration(seconds: 2),
      () {
        isLoading = false;
        notifyListeners();
      },
    );
    log('password is updated');
  }

  String? validateNewUpdatePassword(String password, String currentPassword) {
    if (password.isEmpty) {
      return 'field is empty';
    } else if (!passwordRegExp.hasMatch(password)) {
      return 'Password must be at least 8 characters, include upper, lower, number & special character';
    } else if (password == currentPassword) {
      return 'The new password cannot be the same as the current password.';
    }

    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (password.isEmpty || confirmPassword.isEmpty) {
      return 'field is required';
    } else if (password != confirmPassword) {
      return 'Password does not match';
    }

    return null;
  }

  String? validateName(String name) {
    if (name.isEmpty) return 'name is required';
    return null;
  }

  String? validateEmailLogin({required String email}) {
    if (email.isEmpty) {
      return 'field is empty';
    }

    return null;
  }

  String? validatePassworsLogin({required String pass}) {
    if (pass.isEmpty) {
      return 'field is empty';
    }
    notifyListeners();
    return null;
  }
}
