import 'package:datakap/features/registration/data/models/registration_model.dart';
import 'package:hive/hive.dart';

abstract class RegistrationLocalDataSource {
  Future<void> upsert(RegistrationModel model);
  Future<List<RegistrationModel>> getAll();
  Future<List<RegistrationModel>> getPending();
  Future<void> delete(String id);
}

class RegistrationLocalDataSourceImpl implements RegistrationLocalDataSource {
  static const String _boxName = 'registration_cache';

  Future<Box<RegistrationModel>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox<RegistrationModel>(_boxName);
    }
    return Hive.box<RegistrationModel>(_boxName);
  }

  @override
  Future<void> upsert(RegistrationModel model) async {
    final box = await _openBox();
    await box.put(model.id, model);
  }

  @override
  Future<List<RegistrationModel>> getAll() async {
    final box = await _openBox();
    return box.values.toList(growable: false);
  }

  @override
  Future<List<RegistrationModel>> getPending() async {
    final box = await _openBox();
    return box.values.where((model) => !model.isSynced).toList(growable: false);
  }

  @override
  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}
