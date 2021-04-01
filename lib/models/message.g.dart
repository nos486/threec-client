// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 3;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message()
      ..id = fields[0] as String
      ..author = fields[1] as User
      ..chat = fields[2] as Chat
      ..reply = fields[3] as Message
      ..type = fields[4] as MessageType
      ..text = fields[5] as String
      ..hash = fields[6] as String
      ..createdAt = fields[7] as DateTime
      ..decrypted = fields[8] as bool
      ..decryptedText = fields[9] as String;
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.chat)
      ..writeByte(3)
      ..write(obj.reply)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.text)
      ..writeByte(6)
      ..write(obj.hash)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.decrypted)
      ..writeByte(9)
      ..write(obj.decryptedText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
