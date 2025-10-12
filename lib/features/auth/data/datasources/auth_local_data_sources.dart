import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSources {
  Future<void> saveLoginState(String uid, String email , String name  , String password ,bool isGoogleSignedIn) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('isLogin', true);
    pref.setBool('isGoogleSignedIn', isGoogleSignedIn);
    pref.setString('uid', uid);
    pref.setString('email', email);
    pref.setString('name', name);
    pref.setString('password', password);
  }

  Future?getUid() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('uid');
  }
  Future getName() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('name');
  }
  Future getPassword() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('password');
  }

  Future getEmail() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('email');
  }

  Future isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('isLogin');
  }
  Future isGoogleSignedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('isGoogleSignedIn');
  }
}
