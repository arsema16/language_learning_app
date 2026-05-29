import 'package:hive/hive.dart';

class Word {
  final String id;
  final String word;
  final String translation;
  final String category;
  final String example;
  final int difficulty;
  int correctCount;
  int wrongCount;
  DateTime lastReviewed;

  Word({
    required this.id,
    required this.word,
    required this.translation,
    required this.category,
    required this.example,
    required this.difficulty,
    this.correctCount = 0,
    this.wrongCount = 0,
    DateTime? lastReviewed,
  }) : lastReviewed = lastReviewed ?? DateTime.now();

  double get successRate {
    final total = correctCount + wrongCount;
    if (total == 0) return 0;
    return correctCount / total;
  }

  Word copyWith({
    String? id,
    String? word,
    String? translation,
    String? category,
    String? example,
    int? difficulty,
    int? correctCount,
    int? wrongCount,
    DateTime? lastReviewed,
  }) {
    return Word(
      id: id ?? this.id,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      category: category ?? this.category,
      example: example ?? this.example,
      difficulty: difficulty ?? this.difficulty,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      lastReviewed: lastReviewed ?? this.lastReviewed,
    );
  }
}

// Manual Hive Adapter (no .g.dart file needed)
class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 0;

  @override
  Word read(BinaryReader reader) {
    return Word(
      id: reader.readString(),
      word: reader.readString(),
      translation: reader.readString(),
      category: reader.readString(),
      example: reader.readString(),
      difficulty: reader.readInt(),
      correctCount: reader.readInt(),
      wrongCount: reader.readInt(),
      lastReviewed: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.word);
    writer.writeString(obj.translation);
    writer.writeString(obj.category);
    writer.writeString(obj.example);
    writer.writeInt(obj.difficulty);
    writer.writeInt(obj.correctCount);
    writer.writeInt(obj.wrongCount);
    writer.writeString(obj.lastReviewed.toIso8601String());
  }
}