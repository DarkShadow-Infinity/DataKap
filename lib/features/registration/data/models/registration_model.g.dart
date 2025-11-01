// GENERATED CODE - HAND WRITTEN ADAPTER

part of 'registration_model.dart';

class RegistrationModelAdapter extends TypeAdapter<RegistrationModel> {
  @override
  final int typeId = 0;

  @override
  RegistrationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return RegistrationModel(
      id: fields[0] as String,
      role: fields[1] as String,
      requiresPhoto: fields[2] as bool,
      fields: (fields[3] as Map).cast<String, String>(),
      photoPath: fields[4] as String?,
      createdAt: fields[5] as DateTime,
      syncedAt: fields[6] as DateTime?,
      isSynced: fields[7] as bool,
      syncError: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RegistrationModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.requiresPhoto)
      ..writeByte(3)
      ..write(obj.fields)
      ..writeByte(4)
      ..write(obj.photoPath)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.syncedAt)
      ..writeByte(7)
      ..write(obj.isSynced)
      ..writeByte(8)
      ..write(obj.syncError);
  }
}
