import 'package:hive/hive.dart';

class UserProgress {
  int streak;
  int totalPoints;
  int lessonsCompleted;
  int wordsLearned;
  DateTime lastActive;
  Map<String, int> categoryProgress;

  UserProgress({
    this.streak = 0,
    this.totalPoints = 0,
    this.lessonsCompleted = 0,
    this.wordsLearned = 0,
    DateTime? lastActive,
    Map<String, int>? categoryProgress,
  }) : lastActive = lastActive ?? DateTime.now(),
       categoryProgress = categoryProgress ?? {};

  UserProgress copyWith({
    int? streak,
    int? totalPoints,
    int? lessonsCompleted,
    int? wordsLearned,
    DateTime? lastActive,
    Map<String, int>? categoryProgress,
  }) {
    return UserProgress(
      streak: streak ?? this.streak,
      totalPoints: totalPoints ?? this.totalPoints,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      lastActive: lastActive ?? this.lastActive,
      categoryProgress: categoryProgress ?? this.categoryProgress,
    );
  }
}

// Manual Hive Adapter
class UserProgressAdapter extends TypeAdapter<UserProgress> {
  @override
  final int typeId = 2;

  @override
  UserProgress read(BinaryReader reader) {
    return UserProgress(
      streak: reader.readInt(),
      totalPoints: reader.readInt(),
      lessonsCompleted: reader.readInt(),
      wordsLearned: reader.readInt(),
      lastActive: DateTime.parse(reader.readString()),
      categoryProgress: reader.readMap()?.cast<String, int>() ?? {},
    );
  }

  @override
  void write(BinaryWriter writer, UserProgress obj) {
    writer.writeInt(obj.streak);
    writer.writeInt(obj.totalPoints);
    writer.writeInt(obj.lessonsCompleted);
    writer.writeInt(obj.wordsLearned);
    writer.writeString(obj.lastActive.toIso8601String());
    writer.writeMap(obj.categoryProgress);
  }
}