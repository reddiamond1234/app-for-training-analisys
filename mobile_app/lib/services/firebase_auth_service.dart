import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../util/either.dart';
import '../util/failures/auth_failure.dart';
import '../util/failures/failure.dart';

class FirebaseAuthService {
  static FirebaseAuthService? _instance;

  static FirebaseAuthService get instance => _instance!;

  FirebaseAuthService._({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  factory FirebaseAuthService({
    required FirebaseAuth firebaseAuth,
  }) {
    if (_instance != null) {
      throw StateError("FirebaseAuthService already created");
    }
    _instance = FirebaseAuthService._(
      firebaseAuth: firebaseAuth,
    );

    return _instance!;
  }

  final FirebaseAuth _firebaseAuth;

  User? getCurrentUser() => _firebaseAuth.currentUser;

  bool isUserLoggedIn() => _firebaseAuth.currentUser != null;

  Future<Either<AuthFailure, User?>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print(email);
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 10));

      return value(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return error(AuthFailure.fromStatusCode(e.code));
    } catch (e) {
      if (e is TimeoutException) {
        return error(const TimeoutFailure());
      }
      return error(const UnknownAuthFailure());
    }
  }

  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
      return value(null);
    } on FirebaseAuthException catch (_) {
      return error(const RequiredLoginFailure());
    } catch (e) {
      return error(const UnknownAuthFailure());
    }
  }

  // Helpers

  Future<Either<AuthFailure, void>> signOut() async {
    try {
      return value(await FirebaseAuth.instance.signOut());
    } catch (_) {
      return error(const UnknownAuthFailure());
    }
  }

  Future<Either<AuthFailure, User?>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return value(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return error(AuthFailure.fromStatusCode(e.code));
    } on Exception catch (_) {
      return error(const UnknownAuthFailure());
    } catch (_) {
      return error(const UnknownAuthFailure());
    }
  }

  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return value(null);
    } catch (e) {
      if (e is FirebaseAuthException) {
        return error(AuthFailure.fromStatusCode(e.code));
      }
      return error(const BackendFailure());
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
