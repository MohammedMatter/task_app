

import 'package:task_app/features/auth/data/datasources/auth_local_data_sources.dart';
import 'package:task_app/features/auth/data/datasources/firebase_auth_data_source.dart';

import 'package:task_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_app/features/user/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  FirebaseAuthDataSource _authDataSource;
  AuthLocalDataSources _authLocalDataSources;
  AuthRepositoryImpl(this._authDataSource, this._authLocalDataSources);

  @override
  Future<UserApp> signIn(String email, String password) async {
    final user = await _authDataSource.signIn(email, password);
    if (user.uid != null)
      _authLocalDataSources.saveLoginState(user.uid!, email, user.name! , password ,false );
    return user;
  }

  @override
  Future<UserApp> signUp(String email, String password, String name) {
    return _authDataSource.signUp(email, password, name);
  }

  @override
  Future<UserApp> signInAsGuest() {
    return _authDataSource.signInAsGuest();
  }

  Future? getUid() async {
    final uid = await _authLocalDataSources.getUid();

    return  uid;
  }

  @override
  Future<bool> isLoggedIn() async {
    final isLogin = await _authLocalDataSources.isLoggedIn();
    return isLogin ?? false;
  }

  @override
  Future<String> getEmail() async {
    final email = await _authLocalDataSources.getEmail();
    return email;
  }

  @override
  Future saveLoginState(String uid, String email, String name , String password , bool isGoogleSignedIn)async {
    return await  _authLocalDataSources.saveLoginState(uid, email, name ,password ,isGoogleSignedIn);
  }

  @override
  Future signOut() {
    return _authDataSource.signOutWithGoogle();
  }

  @override
  Future<UserApp?> signInWithGoogle() async {
  return _authDataSource.signInWithGoogle();
 
 
  }

  @override
  Future signOutWithGoogle() async {
    return _authDataSource.signOutWithGoogle();
  }
  
  @override
  Future updatePassword(String newPassword , String oldPassword)async {
  
   return _authDataSource.updatePassword(newPassword , oldPassword);
  }
  
  @override
  Future<String> getPassword() async{
   String password =await  _authLocalDataSources.getPassword() ; 
    return password ; 
  }
}
