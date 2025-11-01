import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datakap/features/registration/data/models/registration_model.dart';

abstract class RegistrationRemoteDataSource {
  Future<void> sendRegistration(RegistrationModel model);
}

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  RegistrationRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<void> sendRegistration(RegistrationModel model) async {
    final collection = _firestore.collection('registrations');
    await collection.doc(model.id).set({
      'role': model.role,
      'requiresPhoto': model.requiresPhoto,
      'fields': model.fields,
      'photoPath': model.photoPath,
      'createdAt': model.createdAt.toIso8601String(),
      'syncedAt': DateTime.now().toIso8601String(),
    });
  }
}
