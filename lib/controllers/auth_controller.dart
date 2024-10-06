import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser(String name, String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    UserModel user = UserModel(name: name, email: email);
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set(user.toMap());
  }

  Future<void> loginUser(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  Stream<User?> get userStream => _auth.authStateChanges();
}
