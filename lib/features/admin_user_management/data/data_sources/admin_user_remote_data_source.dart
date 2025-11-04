import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datakap/features/admin_user_management/data/models/admin_user_model.dart';

abstract class AdminUserRemoteDataSource {
  Stream<List<AdminUserModel>> watchUsers();
  Future<AdminUserModel> getUser(String id);
  Future<void> createUser(AdminUserModel user);
  Future<void> updateUser(AdminUserModel user);
  Future<void> deleteUser(String id);
}

class AdminUserRemoteDataSourceImpl implements AdminUserRemoteDataSource {
  final FirebaseFirestore firestore;

  AdminUserRemoteDataSourceImpl({required this.firestore});

  CollectionReference<AdminUserModel> get _collection =>
      firestore.collection('users').withConverter<AdminUserModel>(
        fromFirestore: (snapshot, _) => AdminUserModel.fromFirestore(snapshot),
        toFirestore: (user, _) => user.toJson(),
      );

  @override
  Stream<List<AdminUserModel>> watchUsers() {
    return _collection.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  @override
  Future<AdminUserModel> getUser(String id) async {
    final snapshot = await _collection.doc(id).get();
    if (!snapshot.exists) {
      throw Exception('User not found');
    }
    return snapshot.data()!;
  }

  @override
  Future<void> createUser(AdminUserModel user) {
    return _collection.doc(user.id).set(user);
  }

  @override
  Future<void> updateUser(AdminUserModel user) {
    return _collection.doc(user.id).update(user.toJson());
  }

  @override
  Future<void> deleteUser(String id) {
    return _collection.doc(id).delete();
  }
}
