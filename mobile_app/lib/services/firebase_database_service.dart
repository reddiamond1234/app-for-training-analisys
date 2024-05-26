import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../util/either.dart';
import '../../util/failures/failure.dart';
import '../../util/logger.dart';

class FirebaseDatabaseService {
  static FirebaseDatabaseService? _instance;

  static FirebaseDatabaseService get instance => _instance!;

  final FirebaseFirestore _firestore;

  final Logger _logger;

  factory FirebaseDatabaseService({required Logger logger}) {
    _instance ??= FirebaseDatabaseService._(logger: logger);

    return _instance!;
  }

  FirebaseDatabaseService._({required Logger logger})
      : _firestore = FirebaseFirestore.instance,
        _logger = logger;

  static List<T> querySnapshotToList<T>({
    required QuerySnapshot<Map<String, dynamic>> querySnapshot,
    required T Function(Map<String, dynamic> data) fromJson,
  }) {
    final List<T> list = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      final Map<String, dynamic> data = doc.data();
      data['id'] = doc.id;
      try {
        list.add(fromJson(data));
      } catch (_) {
        debugPrint(_.toString());
      }
    }
    return list;
  }

  Future<Either<Failure, List<BVUser>>> getUsers() async {
    late final QuerySnapshot<Map<String, dynamic>> querySnapshot;
    try {
      querySnapshot = await _firestore
          .collection('users')
          .get()
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      return error(const TimeOutFailure());
    }

    final List<BVUser> users = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      final Map<String, dynamic> data = doc.data();
      data['id'] = doc.id;

      try {
        final BVUser user = BVUser.fromJson(data);
        users.add(user);
      } catch (_) {
        debugPrint(_.toString());
      }
    }

    return value(users);
  }

  Future<Either<Failure, BVUser>> getUserData(String userId) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (!documentSnapshot.exists) {
        return error(const NotFoundFailure());
      }
      final Map<String, dynamic> data;

      try {
        data = documentSnapshot.data() as Map<String, dynamic>;
      } catch (e) {
        return error(const FromJsonFailure());
      }

      data['id'] = userId;

      return value(BVUser.fromJson(data));
    } catch (e) {
      _logger.error("getUserData", e);
      return error(const BackendFailure());
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream(String path) {
    return _firestore.doc(path).snapshots();
  }

  String get randomId => _firestore.collection('tmp').doc().id;

  Future<Either<Failure, void>> deleteDocument(String path) async {
    try {
      await _firestore.doc(path).delete();
      return value(null);
    } catch (_) {
      return error(const BackendFailure());
    }
  }

  Future<Either<Failure, void>> setDocument(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.doc(path).set(data);
      return value(null);
    } catch (_) {
      return error(const BackendFailure());
    }
  }

  void printLongList(List list) {
    for (var i = 0; i < list.length; i++) {
      print('${list[i]}');
    }
  }
}

abstract class FirebaseDocumentNumbersPath {
  static const String users = 'users';
  static const String tasks = 'tasks';
}

enum ConditionTypes {
  isEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  contains;
}
