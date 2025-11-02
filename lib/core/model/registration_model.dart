import 'package:hive/hive.dart';

part 'registration_model.g.dart';

@HiveType(typeId: 0)
class RegistrationModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  RegistrationModel({required this.name, required this.email});
}
