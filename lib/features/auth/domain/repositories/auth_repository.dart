import 'package:task_app/features/user/domain/entities/user.dart';

abstract class AuthRepository {
  Future<UserApp?> signIn(String email, String password);
  Future<UserApp?> signInWithGoogle();
  Future updatePassword(String password, String oldPassword);
  Future signOutWithGoogle();
  Future<UserApp> signUp(String email, String password, String name);
  Future signOut();
  Future<UserApp> signInAsGuest();
  Future<bool> isLoggedIn();
  Future? getUid();
  Future<String> getEmail();
  Future<String> getPassword();
  Future saveLoginState(String uid, String email, String name, String password,bool isGoogleSignedIn);
}
