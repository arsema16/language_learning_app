import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../widgets/flashcard_widget.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  int currentIndex = 0;
  bool showTranslation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Vocabulary'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildCategoryFilter(),
        ),
      ),
      body: Consumer<LanguageProvider>(
        builder: (context, provider, child) {
          final words = provider.words;
          
          if (words.isEmpty) {
            return const Center(child: Text('No words found'));
          }
          
          final currentWord = words[currentIndex];
          
          return Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (currentIndex + 1) / words.length,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
              const SizedBox(height: 20),
              
              // Flashcard
              Expanded(
                child: FlashcardWidget(
                  word: currentWord,
                  showTranslation: showTranslation,
                  onTap: () {
                    setState(() {
                      showTranslation = !showTranslation;
                    });
                  },
                ),
              ),
              
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: currentIndex > 0
                          ? () {
                              setState(() {
                                currentIndex--;
                                showTranslation = false;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await provider.updateWordProgress(currentWord.id, true);
                        if (currentIndex + 1 < words.length) {
                          setState(() {
                            currentIndex++;
                            showTranslation = false;
                          });
                        } else {
                          _showCompletionDialog();
                        }
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('I Know'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await provider.updateWordProgress(currentWord.id, false);
                        setState(() {
                          showTranslation = false;
                        });
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Need Practice'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: currentIndex + 1 < words.length
                          ? () {
                              setState(() {
                                currentIndex++;
                                showTranslation = false;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<LanguageProvider>(
      builder: (context, provider, child) {
        final categories = provider.getCategories();
        
        return Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = provider.selectedCategory == category;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    provider.setCategory(category);
                    setState(() {
                      currentIndex = 0;
                      showTranslation = false;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: Colors.deepPurple.shade100,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Congratulations!'),
        content: const Text('You completed all words in this category!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Back to Menu'),
          ),
        ],
      ),
    );
  }
}