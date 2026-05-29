import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<LanguageProvider>(
        builder: (context, provider, child) {
          final categories = provider.getCategories();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsCard(provider),
                const SizedBox(height: 20),
                const Text(
                  'Category Progress',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...categories.map((category) => _buildCategoryProgress(provider, category)),
                const SizedBox(height: 20),
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildRecentWords(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(LanguageProvider provider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat('Total Points', provider.progress.totalPoints.toString(), Icons.star),
            _buildStat('Streak', '${provider.progress.streak} days', Icons.local_fire_department),
            _buildStat('Lessons', '${provider.progress.lessonsCompleted}', Icons.check_circle),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.deepPurple),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCategoryProgress(LanguageProvider provider, String category) {
    if (category == 'All') return const SizedBox();
    
    final progress = provider.getCategoryProgress(category);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${(progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentWords(LanguageProvider provider) {
    final recentWords = provider.words.where((w) => w.lastReviewed.isAfter(DateTime.now().subtract(const Duration(days: 7)))).toList();
    
    if (recentWords.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text('No recent activity')),
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentWords.length,
      itemBuilder: (context, index) {
        final word = recentWords[index];
        final successRate = word.successRate;
        
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: successRate > 0.7 ? Colors.green : Colors.orange,
            child: Text('${(successRate * 100).round()}%'),
          ),
          title: Text(word.word),
          subtitle: Text(word.translation),
          trailing: Text(
            '${word.correctCount}/${word.correctCount + word.wrongCount} correct',
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }
}