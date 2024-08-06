// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'urmytalk_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UrMyTokenAdapter extends TypeAdapter<UrMyToken> {
  @override
  final int typeId = 10;

  @override
  UrMyToken read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UrMyToken(
      token: fields[0] as String,
      firebasetoken: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UrMyToken obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.firebasetoken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UrMyTokenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
