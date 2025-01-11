// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormDataModelAdapter extends TypeAdapter<FormDataModel> {
  @override
  final int typeId = 0;

  @override
  FormDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormDataModel(
      name: fields[0] as String,
      email: fields[1] as String,
      picture: fields[2] as String,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FormDataModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.picture)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
