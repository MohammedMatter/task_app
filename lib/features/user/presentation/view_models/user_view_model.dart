import 'package:flutter/material.dart';
import 'package:task_app/features/auth/data/datasources/auth_local_data_sources.dart';
import 'package:task_app/features/user/domain/entities/user.dart';

class UserViewModel extends ChangeNotifier {
  UserApp? _user;
  UserApp? get user => _user;
  final AuthLocalDataSources _localDataSources = AuthLocalDataSources();
  void setUser(UserApp newUser) {
    _user = newUser;
    notifyListeners();
  }

  void loadUser() async {
    final uid = await _localDataSources.getUid();
    final email = await _localDataSources.getEmail();
    final name = await _localDataSources.getName();
    final password  = await _localDataSources.getPassword() ; 
    final isGoogleSignedIn  = await _localDataSources.isGoogleSignedIn() ; 
    _user = UserApp(email: email, uid: uid, name: name , password: password,isGoogleSignedIn: isGoogleSignedIn);
    notifyListeners();
  }
}
