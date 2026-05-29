import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/word.dart';

class FlashcardWidget extends StatelessWidget {
  final Word word;
  final bool showTranslation;
  final VoidCallback onTap;
  final FlutterTts _flutterTts = FlutterTts();

  FlashcardWidget({
    super.key,
    required this.word,
    required this.showTranslation,
    required this.onTap,
  });

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage('fr-FR');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                showTranslation ? Icons.translate : Icons.question_mark,
                size: 60,
                color: showTranslation ? Colors.green : Colors.deepPurple,
              ),
              const SizedBox(height: 30),
              Text(
                showTranslation ? word.translation : word.word,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (showTranslation) ...[
                const SizedBox(height: 20),
                Text(
                  'Example: ${word.example}',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 30),
                  onPressed: () => _speak(word.word),
                  color: Colors.deepPurple,
                ),
              ],
              if (!showTranslation)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    '👆 Tap to reveal translation',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}