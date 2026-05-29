import '../models/word.dart';
import '../models/lesson.dart';

class SampleData {
  static List<Word> getSampleWords() {
    return [
      // Vocabulary Category
      Word(
        id: '1',
        word: 'Hello',
        translation: 'Bonjour',
        category: 'Vocabulary',
        example: 'Hello, how are you?',
        difficulty: 1,
      ),
      Word(
        id: '2',
        word: 'Goodbye',
        translation: 'Au revoir',
        category: 'Vocabulary',
        example: 'Goodbye, see you tomorrow!',
        difficulty: 1,
      ),
      Word(
        id: '3',
        word: 'Thank you',
        translation: 'Merci',
        category: 'Vocabulary',
        example: 'Thank you for your help.',
        difficulty: 1,
      ),
      Word(
        id: '4',
        word: 'Please',
        translation: 'S\'il vous plaît',
        category: 'Vocabulary',
        example: 'Please help me.',
        difficulty: 1,
      ),
      
      // Grammar Category
      Word(
        id: '5',
        word: 'I am',
        translation: 'Je suis',
        category: 'Grammar',
        example: 'I am a student.',
        difficulty: 2,
      ),
      Word(
        id: '6',
        word: 'You are',
        translation: 'Tu es',
        category: 'Grammar',
        example: 'You are my friend.',
        difficulty: 2,
      ),
      Word(
        id: '7',
        word: 'He/She is',
        translation: 'Il/Elle est',
        category: 'Grammar',
        example: 'She is a doctor.',
        difficulty: 2,
      ),
      
      // Phrases Category
      Word(
        id: '8',
        word: 'What is your name?',
        translation: 'Comment vous appelez-vous?',
        category: 'Phrases',
        example: 'What is your name? My name is John.',
        difficulty: 2,
      ),
      Word(
        id: '9',
        word: 'Where is the bathroom?',
        translation: 'Où sont les toilettes?',
        category: 'Phrases',
        example: 'Excuse me, where is the bathroom?',
        difficulty: 2,
      ),
      Word(
        id: '10',
        word: 'How much does it cost?',
        translation: 'Combien ça coûte?',
        category: 'Phrases',
        example: 'This is beautiful. How much does it cost?',
        difficulty: 3,
      ),
    ];
  }

  static List<Lesson> getSampleLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Basic Greetings',
        description: 'Learn how to greet people in French',
        category: 'Vocabulary',
        wordIds: ['1', '2', '3', '4'],
      ),
      Lesson(
        id: '2',
        title: 'Essential Verbs',
        description: 'Master the most common verbs',
        category: 'Grammar',
        wordIds: ['5', '6', '7'],
      ),
      Lesson(
        id: '3',
        title: 'Common Phrases',
        description: 'Useful phrases for travelers',
        category: 'Phrases',
        wordIds: ['8', '9', '10'],
      ),
    ];
  }
}