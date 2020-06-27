import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Status {
  Uninitialized,
  Unauthenticated,
  Authenticated,
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;

  FirebaseUser get user => _user;

  Future<String> signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user.email;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.message;
    }
  }

  Future<String> signUp(String email, String password) async {

    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user.uid;
    }catch (e){
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.message;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
