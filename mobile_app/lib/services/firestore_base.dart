import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../util/either.dart';
import '../../../util/failures/failure.dart';
import '../../../util/logger.dart';
import '../../models/item_property.dart';

abstract class FirestoreBase<T extends ItemProperty> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath;
  final Logger logger;

  FirestoreBase({
    required this.collectionPath,
    required this.logger,
  });

  final Duration timeOutDuration = const Duration(seconds: 7);

  FirebaseFirestore get firestore => _firestore;

  Future<Either<Failure, T>> addDocument(T object) async {
    try {
      final Map<String, dynamic> data = toJson(object);
      final DocumentReference<Map<String, dynamic>> docRef = await _firestore
          .collection(collectionPath)
          .add(data)
          .timeout(timeOutDuration);
      data['id'] = docRef.id;

      logger.info("addDocument", docRef.id);

      return value(fromJson(data));
    } on FromJsonFailure catch (_) {
      return error(const FromJsonFailure());
    } catch (_) {
      return error(const BackendFailure());
    }
  }

  Future<Either<Failure, T>> setDocument(T object) async {
    try {
      final Map<String, dynamic> data = toJson(object);
      await _firestore
          .collection(collectionPath)
          .doc(object.id)
          .set(data)
          .timeout(timeOutDuration);

      logger.info("setDocument ", object.id);

      return value(object);
    } on FromJsonFailure catch (_) {
      return error(const FromJsonFailure());
    } catch (_) {
      return error(const BackendFailure());
    }
  }

  Future<Either<Failure, List<T>>> getAll() async {
    late final QuerySnapshot<Map<String, dynamic>> querySnapshot;

    try {
      querySnapshot = await _firestore
          .collection(collectionPath)
          .get()
          .timeout(timeOutDuration);
    } catch (e) {
      return error(const FromJsonFailure());
    }

    final List<T> documents = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      final Map<String, dynamic> data = doc.data();
      data['id'] = doc.id;

      try {
        final T document = fromJson(data);
        documents.add(document);
      } catch (_) {
        debugPrint(_.toString());
      }
    }

    return value(documents);
  }

  Future<Either<Failure, void>> updateDocument(T item) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(item.id)
          .update(toJson(item))
          .timeout(timeOutDuration);
      return value(null);
    } catch (_) {
      return error(const BackendFailure());
    }
  }

  Future<Either<Failure, void>> updateDocumentData({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(id)
          .update(data)
          .timeout(timeOutDuration);
      return value(null);
    } catch (_) {
      return error(const BackendFailure());
    }
  }

  Future<Either<Failure, void>> deleteDocument(String id) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(id)
          .delete()
          .timeout(timeOutDuration);
      return value(null);
    } catch (e) {
      logger.error("deleteDocument", e);
      return error(const BackendFailure());
    }
  }

  Future<Either<Failure, T>> getItem(String? id) async {
    if (id == null) return error(const NotFoundFailure());
    final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection(collectionPath)
        .doc(id)
        .get()
        .timeout(timeOutDuration);

    if (!doc.exists) {
      return error(const NotFoundFailure());
    }

    try {
      return value(fromDocumentSnapshot(doc));
    } catch (e) {
      logger.error("getItem", e);
      return error(const BackendFailure());
    }
  }

  T fromJson(Map<String, dynamic> json);

  T fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data()!;
    data['id'] = doc.id;

    return fromJson(data);
  }

  Map<String, dynamic> toJson(T instance);

  Stream<QuerySnapshot<Map<String, dynamic>>> itemsStream(
    String userId,
  );
}
