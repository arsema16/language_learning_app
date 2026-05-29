import 'package:hive/hive.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> wordIds;
  bool isCompleted;
  int progress;
  DateTime? completedDate;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.wordIds,
    this.isCompleted = false,
    this.progress = 0,
    this.completedDate,
  });

  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    List<String>? wordIds,
    bool? isCompleted,
    int? progress,
    DateTime? completedDate,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      wordIds: wordIds ?? this.wordIds,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

// Manual Hive Adapter
class LessonAdapter extends TypeAdapter<Lesson> {
  @override
  final int typeId = 1;

  @override
  Lesson read(BinaryReader reader) {
    return Lesson(
      id: reader.readString(),
      title: reader.readString(),
      description: reader.readString(),
      category: reader.readString(),
      wordIds: reader.readStringList() ?? [],
      isCompleted: reader.readBool(),
      progress: reader.readInt(),
      completedDate: reader.readBool() ? DateTime.parse(reader.readString()) : null,
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeString(obj.category);
    writer.writeStringList(obj.wordIds);
    writer.writeBool(obj.isCompleted);
    writer.writeInt(obj.progress);
    writer.writeBool(obj.completedDate != null);
    if (obj.completedDate != null) {
      writer.writeString(obj.completedDate!.toIso8601String());
    }
  }
}