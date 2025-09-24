import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp(String email, String password);
  Future<UserModel> logIn(String email, String password);
  Future<void> logOut();
  Stream<UserModel?> get user;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserModel> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final userModel = UserModel(uid: user.uid, email: user.email!);
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toFirestore());
        return userModel;
      } else {
        throw ServerException("Sign up failed: User is null");
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? "An unknown error occurred");
    }
  }

  @override
  Future<UserModel> logIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return UserModel(uid: user.uid, email: user.email!);
      } else {
        throw ServerException("Login failed: User is null");
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? "An unknown error occurred");
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser != null
          ? UserModel.fromFirebaseUser(firebaseUser)
          : null;
    });
  }
}
