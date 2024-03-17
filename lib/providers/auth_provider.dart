import 'package:flutter/material.dart';

import '../database/UserDao.dart';
import '../database/model/User.dart' as my_user;
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  User? firebaseUser;
  my_user.User? databaseUser;

  Future<void> register(
      String email, String password, String fullName, String username) async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await UserDao.createUser(
      my_user.User(
          id: credential.user?.uid,
          fullName: fullName,
          email: email,
          username: username),
    );
  }

  Future<void> login(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    var user = await UserDao.getUser(credential.user?.uid);
    databaseUser = user;
    firebaseUser = credential.user;
  }

  void logout() {
    databaseUser = null;
    FirebaseAuth.instance.signOut();
  }

  bool isUserLoggedInBefore() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> retrieveUserFromDatabase() async {
    firebaseUser = FirebaseAuth.instance.currentUser;
    databaseUser = await UserDao.getUser(firebaseUser!.uid);
  }
}
