import 'package:datakap/features/auth/data/models/user_model.dart';
import 'package:hive/hive.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getUserByUid(String uid);
  Future<UserModel?> getUserByEmail(String email);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _boxName = 'auth_cache';
  static const String _usersByUidKey = 'users_by_uid';
  static const String _usersByEmailKey = 'users_by_email';

  Future<Box> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final box = await _openBox();
    final byUid = Map<String, dynamic>.from(
      box.get(_usersByUidKey, defaultValue: <String, dynamic>{}),
    );
    final byEmail = Map<String, dynamic>.from(
      box.get(_usersByEmailKey, defaultValue: <String, dynamic>{}),
    );

    final json = user.toJson();
    byUid[user.uid] = json;
    byEmail[user.email.toLowerCase()] = json;

    await box.put(_usersByUidKey, byUid);
    await box.put(_usersByEmailKey, byEmail);
  }

  @override
  Future<UserModel?> getUserByUid(String uid) async {
    final box = await _openBox();
    final byUid = Map<String, dynamic>.from(
      box.get(_usersByUidKey, defaultValue: <String, dynamic>{}),
    );
    final data = byUid[uid] as Map<dynamic, dynamic>?;
    if (data == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    final box = await _openBox();
    final byEmail = Map<String, dynamic>.from(
      box.get(_usersByEmailKey, defaultValue: <String, dynamic>{}),
    );
    final data = byEmail[email.toLowerCase()] as Map<dynamic, dynamic>?;
    if (data == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }
}
