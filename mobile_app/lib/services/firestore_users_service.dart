import 'package:cloud_firestore/cloud_firestore.dart';

import '../../util/logger.dart';
import '../models/user.dart';
import 'firestore_base.dart';

class FirestoreUsersService extends FirestoreBase<BVUser> {
  FirestoreUsersService()
      : super(collectionPath: 'users', logger: Logger.instance);

  @override
  BVUser fromJson(Map<String, dynamic> json) {
    return BVUser.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(BVUser instance) => instance.toJson();

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> itemsStream(String userId) {
    // TODO: implement itemsStream
    throw UnimplementedError();
  }

  Stream<DocumentSnapshot<BVUser>> userStream(String userID) {
    return super
        .firestore
        .collection(collectionPath)
        .doc(userID)
        .withConverter<BVUser>(
          fromFirestore: (json, _) =>
              BVUser.fromJson(json.data()!..['id'] = json.id),
          toFirestore: (item, _) => item.toJson(),
        )
        .snapshots();
  }

  // I am in a hurry so this is here. Should refactor to separate service
  /*Future<Either<Failure, List<Jaslice>>> getJaslice() async {
    try {
    final QuerySnapshot<List<Jaslice>> querySnapshot =
        await super
            .firestore
            .collection('jaslice')
            .withConverter<Jaslice>(
              fromFirestore: (json, _) =>
                  Jaslice.fromMap(json.data()!..['id'] = json.id),
              toFirestore: (item, _) => item.toMap(),
            )
            .get()
            .timeout(const Duration(seconds: 10)),

    return value(querySnapshot.docs.map((e) => e.data()).toList());
    } catch (e) {
      return error(const BackendFailure());
    }
  }*/
}
