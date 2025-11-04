import 'package:datakap/features/auth/data/models/user_model.dart';
import 'package:hive/hive.dart';

// Contrato para el almacenamiento local de la sesión de usuario.
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _boxName = 'auth_cache';
  static const String _userKey = 'current_user';

  Future<Box> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final box = await _openBox();
    // Guarda el usuario como un mapa JSON bajo una clave única.
    await box.put(_userKey, user.toJson());
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final box = await _openBox();
    final data = box.get(_userKey);

    if (data != null) {
      // Si se encuentra un usuario, lo decodifica desde el mapa JSON.
      return UserModel.fromJson(Map<String, dynamic>.from(data as Map));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    final box = await _openBox();
    // Elimina solo la clave del usuario, manteniendo otros datos si los hubiera.
    await box.delete(_userKey);
  }
}
