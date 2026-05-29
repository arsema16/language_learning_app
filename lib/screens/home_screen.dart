import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import 'learn_screen.dart';
import 'quiz_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade700,
              Colors.purple.shade500,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildStats(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            children: [
                              _buildMenuCard(
                                context,
                                'Learn',
                                Icons.school,
                                Colors.blue,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LearnScreen()),
                                ),
                              ),
                              _buildMenuCard(
                                context,
                                'Practice',
                                Icons.quiz,
                                Colors.green,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                                ),
                              ),
                              _buildMenuCard(
                                context,
                                'Progress',
                                Icons.bar_chart,
                                Colors.orange,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProgressScreen()),
                                ),
                              ),
                              _buildMenuCard(
                                context,
                                'Words',
                                Icons.menu_book,
                                Colors.purple,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LearnScreen()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Learn French',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Master French with interactive lessons',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Consumer<LanguageProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '🔥',
                '${provider.progress.streak}',
                'Day Streak',
              ),
              _buildStatItem(
                '⭐',
                '${provider.progress.totalPoints}',
                'Points',
              ),
              _buildStatItem(
                '📚',
                '${provider.progress.wordsLearned}',
                'Words',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}