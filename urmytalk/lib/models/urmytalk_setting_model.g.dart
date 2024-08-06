// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'urmytalk_setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UrMySettingsAdapter extends TypeAdapter<UrMySettings> {
  @override
  final int typeId = 15;

  @override
  UrMySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UrMySettings(
      min: fields[0] as int,
      max: fields[1] as int,
      delreq: fields[2] as bool,
      autologin: fields[3] as bool,
      needprofileupdate: fields[4] as int,
      introduction: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UrMySettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.min)
      ..writeByte(1)
      ..write(obj.max)
      ..writeByte(2)
      ..write(obj.delreq)
      ..writeByte(3)
      ..write(obj.autologin)
      ..writeByte(4)
      ..write(obj.needprofileupdate)
      ..writeByte(5)
      ..write(obj.introduction);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UrMySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
