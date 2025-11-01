import 'package:datakap/features/auth/domain/entities/user_entity.dart';

class RegistrationRequest {
  RegistrationRequest({
    required this.role,
    required this.fields,
    required this.requiresPhoto,
    this.photoPath,
  });

  final UserRole role;
  final Map<String, String> fields;
  final bool requiresPhoto;
  final String? photoPath;
}
