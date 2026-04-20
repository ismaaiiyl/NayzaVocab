// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab_set_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VocabSetModelAdapter extends TypeAdapter<VocabSetModel> {
  @override
  final int typeId = 0;

  @override
  VocabSetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VocabSetModel(
      id: fields[0] as String,
      title: fields[1] as String,
      words: (fields[2] as List).cast<WordModel>(),
      createdAt: fields[3] as DateTime,
      folderId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VocabSetModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.words)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.folderId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabSetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
