// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskmodelAdapter extends TypeAdapter<Taskmodel> {
  @override
  final int typeId = 0;

  @override
  Taskmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Taskmodel(
      id: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String,
      date: fields[3] as String,
      priority: fields[4] as String,
      category: fields[5] as String,
      isdone: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Taskmodel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.isdone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
