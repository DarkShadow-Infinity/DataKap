import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datakap/features/admin_user_management/data/models/admin_user_model.dart';

class AdminUserApi {
  AdminUserApi(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users');

  Future<AdminUserModel> fetchData(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
        message: 'No se encontró el usuario solicitado.',
      );
    }
    return AdminUserModel.fromJson(doc.data()!);
  }

  Stream<List<AdminUserModel>> watchUsers() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => AdminUserModel.fromJson(doc.data()))
          .toList(growable: false),
    );
  }

  Future<void> createUser(AdminUserModel model) async {
    await _collection.doc(model.id).set(model.toJson());
  }

  Future<void> updateUser(AdminUserModel model) async {
    await _collection.doc(model.id).update(model.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _collection.doc(id).delete();
  }
}
