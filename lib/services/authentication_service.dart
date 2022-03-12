import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'database_service.dart';

class AuthenticationService {
  FirebaseAuth auth = FirebaseAuth.instance;
  String get getUserID => FirebaseAuth.instance.currentUser!.uid;

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> loginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'User logged in';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        return 'ERROR: No user found';
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
        return 'ERROR: Wrong password provided';
      }
    }
    return null;
  }

  Future<String?> registerNewUser(String email, String password) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(
          'userCredential.additionalUserInfo: $userCredential.additionalUserInfo');
      DatabaseService().addNewUserData();
      return 'User registered';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
        return 'ERROR: The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
        return 'ERROR: The account already exists';
      }
    } catch (e) {
      debugPrint('exceptions: $e');
      return 'ERROR: Auth error';
    }
    return null;
  }
}
