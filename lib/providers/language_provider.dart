import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/word.dart';
import '../models/lesson.dart';
import '../models/user_progress.dart';
import '../data/sample_data.dart';

class LanguageProvider extends ChangeNotifier {
  late Box<Word> _wordsBox;
  late Box<Lesson> _lessonsBox;
  late Box<UserProgress> _progressBox;
  
  List<Word> _words = [];
  List<Lesson> _lessons = [];
  UserProgress _progress = UserProgress();
  
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<Word> get words => _filterWords();
  List<Lesson> get lessons => _lessons;
  UserProgress get progress => _progress;
  String get selectedCategory => _selectedCategory;

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(WordAdapter());
    Hive.registerAdapter(LessonAdapter());
    Hive.registerAdapter(UserProgressAdapter());
    
    _wordsBox = await Hive.openBox<Word>('words');
    _lessonsBox = await Hive.openBox<Lesson>('lessons');
    _progressBox = await Hive.openBox<UserProgress>('progress');
    
    await _loadData();
  }

  Future<void> _loadData() async {
    // Load or initialize words
    if (_wordsBox.isEmpty) {
      for (var word in SampleData.getSampleWords()) {
        await _wordsBox.put(word.id, word);
      }
    }
    _words = _wordsBox.values.toList();
    
    // Load or initialize lessons
    if (_lessonsBox.isEmpty) {
      for (var lesson in SampleData.getSampleLessons()) {
        await _lessonsBox.put(lesson.id, lesson);
      }
    }
    _lessons = _lessonsBox.values.toList();
    
    // Load or initialize progress
    if (_progressBox.isEmpty) {
      await _progressBox.put('progress', UserProgress());
    }
    _progress = _progressBox.get('progress')!;
    
    notifyListeners();
  }

  List<Word> _filterWords() {
    var filtered = _words;
    
    if (_selectedCategory != 'All') {
      filtered = filtered.where((w) => w.category == _selectedCategory).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((w) =>
        w.word.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        w.translation.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<String> getCategories() {
    final categories = _words.map((w) => w.category).toSet().toList();
    return ['All', ...categories];
  }

  Future<void> updateWordProgress(String wordId, bool isCorrect) async {
    final word = _wordsBox.get(wordId);
    if (word != null) {
      final updatedWord = word.copyWith(
        correctCount: word.correctCount + (isCorrect ? 1 : 0),
        wrongCount: word.wrongCount + (isCorrect ? 0 : 1),
        lastReviewed: DateTime.now(),
      );
      await _wordsBox.put(wordId, updatedWord);
      
      // Update word in list
      final index = _words.indexWhere((w) => w.id == wordId);
      if (index != -1) {
        _words[index] = updatedWord;
      }
      
      // Update progress
      if (isCorrect) {
        _progress.totalPoints += 10;
        if (updatedWord.correctCount == 1) {
          _progress.wordsLearned++;
        }
        await _updateStreak();
        await _progressBox.put('progress', _progress);
      }
      
      notifyListeners();
    }
  }

  Future<void> completeLesson(String lessonId) async {
    final lesson = _lessonsBox.get(lessonId);
    if (lesson != null && !lesson.isCompleted) {
      final updatedLesson = lesson.copyWith(
        isCompleted: true,
        progress: 100,
        completedDate: DateTime.now(),
      );
      await _lessonsBox.put(lessonId, updatedLesson);
      
      final index = _lessons.indexWhere((l) => l.id == lessonId);
      if (index != -1) {
        _lessons[index] = updatedLesson;
      }
      
      _progress.lessonsCompleted++;
      _progress.totalPoints += 50;
      await _progressBox.put('progress', _progress);
      
      notifyListeners();
    }
  }

  Future<void> _updateStreak() async {
    final today = DateTime.now();
    final lastActive = _progress.lastActive;
    
    if (lastActive.day == today.day - 1) {
      _progress.streak++;
    } else if (lastActive.day != today.day) {
      _progress.streak = 1;
    }
    
    _progress.lastActive = today;
  }

  List<Word> getDueWords({int limit = 10}) {
    final dueWords = _words.where((w) =>
      w.lastReviewed.isBefore(DateTime.now().subtract(Duration(days: 1)))
    ).toList();
    
    dueWords.sort((a, b) => a.successRate.compareTo(b.successRate));
    return dueWords.take(limit).toList();
  }

  double getCategoryProgress(String category) {
    final categoryWords = _words.where((w) => w.category == category).toList();
    if (categoryWords.isEmpty) return 0;
    
    final learnedWords = categoryWords.where((w) => w.correctCount > 0).length;
    return learnedWords / categoryWords.length;
  }
}