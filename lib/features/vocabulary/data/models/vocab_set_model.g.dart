// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab_set_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VocabSetModelAdapter extends TypeAdapter<VocabSetModel> {
  @override
  final int typeId = 1;

  @override
  VocabSetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VocabSetModel(
      id: fields[0] as String,
      title: fields[1] as String,
      createdAt: fields[2] as DateTime,
      words: (fields[3] as List).cast<WordModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, VocabSetModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.words);
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

class WordModelAdapter extends TypeAdapter<WordModel> {
  @override
  final int typeId = 2;

  @override
  WordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordModel(
      original: fields[0] as String,
      translation: fields[1] as String,
      langCode: fields[2] as String,
      isLearned: fields[3] as bool,
      wrongAttempts: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WordModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.original)
      ..writeByte(1)
      ..write(obj.translation)
      ..writeByte(2)
      ..write(obj.langCode)
      ..writeByte(3)
      ..write(obj.isLearned)
      ..writeByte(4)
      ..write(obj.wrongAttempts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
