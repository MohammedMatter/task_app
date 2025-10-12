import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_app/features/auth/data/datasources/auth_local_data_sources.dart';
import 'package:task_app/features/user/domain/entities/user.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthLocalDataSources _authLocalDataSources = AuthLocalDataSources();
  Future<UserApp> signUp(String email, String password, String name) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    await result.user!.updateDisplayName(name);
    await _authLocalDataSources.saveLoginState(
        result.user!.uid, result.user!.email!, name, password , false);

    return UserApp(
        isGoogleSignedIn: false,
        email: email,
        uid: result.user!.uid,
        name: name,
        password: password);
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserApp> signIn(String email, String password,) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = result.user!;
      await _authLocalDataSources.saveLoginState(
          user.uid, user.email!, user.displayName!, password , false);
      return UserApp(
          isGoogleSignedIn: false,
          email: user.email,
          uid: user.uid,
          name: user.displayName,
          password: password);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<UserApp?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential =
        GoogleAuthProvider.credential(idToken: googleAuth.idToken);
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    final user = userCredential.user;

    await _authLocalDataSources.saveLoginState(
        user!.uid, user.email!, user.displayName!, 'No Password' ,true );
  
    return UserApp(email: user.email, uid: user.uid, name: user.displayName );
  }

  Future signOutWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    await _firebaseAuth.signOut();
  }

  Future<UserApp> signInAsGuest() async {
    try {
      final result = await _firebaseAuth.signInAnonymously();
      final user = result.user;
      await _authLocalDataSources.saveLoginState(
          user!.uid, 'guest@gmail.com', 'Guest', '123456' , true);

      return UserApp(email: result.user!.email, uid: result.user!.uid);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future updatePassword(String newPassword, String oldPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: oldPassword);
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      log('updated password : ${newPassword}');
      await _authLocalDataSources.saveLoginState(
          user.uid, user.email!, user.displayName!, newPassword , false);
      await user.reload();
    }
  }
}
