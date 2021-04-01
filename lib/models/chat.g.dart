// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final int typeId = 2;

  @override
  Chat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chat(
      fields[0] as String,
    )
      ..username = fields[1] as String
      ..name = fields[2] as String
      ..type = fields[3] as String
      ..admin = fields[4] as User
      ..users = (fields[5] as HiveList)?.castHiveList()
      ..createdAt = fields[6] as DateTime
      ..newMessages = fields[7] as int
      ..messages = (fields[8] as HiveList)?.castHiveList();
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.admin)
      ..writeByte(5)
      ..write(obj.users)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.newMessages)
      ..writeByte(8)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
