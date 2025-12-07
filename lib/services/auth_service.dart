import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app("PocketDoctor"),
    databaseURL:
        "https://pocket-doctor-b5458-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref();

  // SIGN UP
  Future<String?> signUp({
    required String fullName,
    required String age,
    required String gender,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCred.user!.uid;

      // save the user profile in realtime database
      await _db.child("users/$uid").set({
        "fullName": fullName,
        "age": age,
        "gender": gender,
        "email": email,
        "reminders": {}, // <-- IMPORTANT: add empty reminders field
      });

      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGIN
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // FORGOT PASSWORD
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // GET CURRENT USER
  User? get currentUser => _auth.currentUser;
}
