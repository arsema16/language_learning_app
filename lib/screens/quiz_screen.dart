import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../models/word.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestion = 0;
  int score = 0;
  bool showResult = false;
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    final words = provider.words;
    
    for (var word in words) {
      questions.add({
        'question': word.word,
        'correct': word.translation,
        'options': _generateOptions(word.translation, words),
      });
    }
    questions.shuffle();
  }

  List<String> _generateOptions(String correct, List<Word> words) {
    final List<String> options = [correct];
    
    // Get unique translations from other words
    final Set<String> otherTranslations = {};
    for (var word in words) {
      if (word.translation != correct) {
        otherTranslations.add(word.translation);
      }
    }
    
    // Convert to list and shuffle
    List<String> otherList = otherTranslations.toList();
    otherList.shuffle();
    
    // Add up to 3 other options
    options.addAll(otherList.take(3));
    options.shuffle();
    
    return options;
  }

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      if (answer == questions[currentQuestion]['correct']) {
        score++;
      }
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestion + 1 < questions.length) {
        setState(() {
          currentQuestion++;
          selectedAnswer = null;
        });
      } else {
        setState(() {
          showResult = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (showResult) {
      final percentage = (score / questions.length * 100).round();
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Results'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  percentage >= 70 ? Icons.emoji_events : Icons.school,
                  size: 100,
                  color: percentage >= 70 ? Colors.amber : Colors.blue,
                ),
                const SizedBox(height: 20),
                Text(
                  'Score: $score/${questions.length}',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 24,
                    color: percentage >= 70 ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  percentage >= 70 
                      ? 'Excellent! Keep up the great work! 🎉'
                      : 'Good effort! Review and try again! 💪',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            currentQuestion = 0;
                            score = 0;
                            showResult = false;
                            selectedAnswer = null;
                            questions.shuffle();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Try Again'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Back to Menu'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = questions[currentQuestion];
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${currentQuestion + 1}/${questions.length}'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (currentQuestion + 1) / questions.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 10),
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            
            // Question card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const Icon(Icons.help_outline, size: 40, color: Colors.deepPurple),
                    const SizedBox(height: 20),
                    Text(
                      'What is the translation of?',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"${question['question']}"',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Answer options
            Expanded(
              child: ListView.builder(
                itemCount: (question['options'] as List<String>).length,
                itemBuilder: (context, index) {
                  final option = (question['options'] as List<String>)[index];
                  bool isSelected = selectedAnswer == option;
                  bool isCorrect = option == question['correct'];
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedAnswer == null ? () => _checkAnswer(option) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? (isCorrect ? Colors.green : Colors.red)
                              : Colors.grey.shade200,
                          foregroundColor: isSelected ? Colors.white : Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}