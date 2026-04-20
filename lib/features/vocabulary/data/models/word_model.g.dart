// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordModelAdapter extends TypeAdapter<WordModel> {
  @override
  final int typeId = 1;

  @override
  WordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordModel(
      id: fields[0] as String,
      original: fields[1] as String,
      translation: fields[2] as String,
      langCode: fields[3] as String?,
      isDifficult: fields[4] as bool,
      wrongAttempts: fields[5] as int,
      correctAnswersCount: fields[6] as int,
      lastTestedAt: fields[7] as DateTime?,
      setId: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.original)
      ..writeByte(2)
      ..write(obj.translation)
      ..writeByte(3)
      ..write(obj.langCode)
      ..writeByte(4)
      ..write(obj.isDifficult)
      ..writeByte(5)
      ..write(obj.wrongAttempts)
      ..writeByte(6)
      ..write(obj.correctAnswersCount)
      ..writeByte(7)
      ..write(obj.lastTestedAt)
      ..writeByte(8)
      ..write(obj.setId);
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
