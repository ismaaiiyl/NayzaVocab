import 'package:hive/hive.dart';

part 'folder_model.g.dart';

@HiveType(typeId: 2)
class FolderModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  final DateTime createdAt;

  FolderModel({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  FolderModel copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
  }) {
    return FolderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FolderModel.fromMap(Map<String, dynamic> map) {
    return FolderModel(
      id: map['id'] as String,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
