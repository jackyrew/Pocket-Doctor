import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

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

      await _db.child("users/$uid").set({
        "fullName": fullName,
        "age": age,
        "gender": gender,
        "email": email,
        "reminders": {},
      });

      return null;
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
      return null;
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

  // GET USER DATA (NEW METHOD)
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final snapshot = await _db.child("users/$uid").get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}
