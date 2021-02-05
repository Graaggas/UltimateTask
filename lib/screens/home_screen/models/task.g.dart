// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[1] as String,
      memo: fields[0] as String,
      color: fields[5] as String,
      creationDate: fields[2] as DateTime,
      doingDate: fields[3] as DateTime,
      isDeleted: fields[7] as bool,
      lastEditDate: fields[4] as DateTime,
      outOfDate: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.memo)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.creationDate)
      ..writeByte(3)
      ..write(obj.doingDate)
      ..writeByte(4)
      ..write(obj.lastEditDate)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.outOfDate)
      ..writeByte(7)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
