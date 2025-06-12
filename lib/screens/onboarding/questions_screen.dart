import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/onboarding_service.dart';
import '../../core/routes/app_router.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int _currentQuestionIndex = 0;
  List<String>? _selectedGenres;
  String? _selectedFrequency;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What movie genres do you like?',
      'type': 'multi_select',
      'options': [
        'Action',
        'Comedy',
        'Drama',
        'Horror',
        'Sci-Fi',
        'Romance',
        'Thriller',
        'Documentary',
      ],
    },
    {
      'question': 'How often do you visit movie locations?',
      'type': 'single_select',
      'options': [
        'Frequently',
        'Occasionally',
        'Rarely',
        'First time',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedGenres = [];
  }

  Future<void> _savePreferences() async {
    final preferences = {
      'preferred_genres': _selectedGenres?.join(','),
      'visit_frequency': _selectedFrequency ?? 'Not specified',
    };
    
    await OnboardingService.saveUserPreferences(preferences);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRouter.login);
  }

  void _handleOptionTap(dynamic option) {
    final currentQuestion = _questions[_currentQuestionIndex];
    
    if (currentQuestion['type'] == 'multi_select') {
      setState(() {
        if (_selectedGenres!.contains(option)) {
          _selectedGenres!.remove(option);
        } else {
          _selectedGenres!.add(option);
        }
      });
    } else {
      setState(() {
        _selectedFrequency = option;
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _savePreferences();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final isLastQuestion = _currentQuestionIndex == _questions.length - 1;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1} of ${_questions.length}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _currentQuestionIndex > 0
              ? () => setState(() => _currentQuestionIndex--)
              : null,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: (_currentQuestionIndex + 1) / _questions.length,
              ),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              currentQuestion['question'],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: (currentQuestion['options'] as List).length,
                itemBuilder: (context, index) {
                  final option = currentQuestion['options'][index];
                  final isSelected = currentQuestion['type'] == 'multi_select'
                      ? _selectedGenres!.contains(option)
                      : _selectedFrequency == option;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? theme.primaryColor
                            : theme.dividerColor,
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected
                          ? theme.primaryColor.withOpacity(0.05)
                          : theme.cardColor,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: theme.primaryColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _handleOptionTap(option),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: isSelected
                                        ? theme.primaryColor
                                        : theme.textTheme.bodyLarge?.color,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: theme.primaryColor,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.vertical,
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                key: ValueKey<bool>((currentQuestion['type'] == 'multi_select'
                        ? _selectedGenres!.isNotEmpty
                        : _selectedFrequency != null)),
                width: double.infinity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: (currentQuestion['type'] == 'multi_select'
                                ? _selectedGenres!.isNotEmpty
                                : _selectedFrequency != null)
                            ? _nextQuestion
                            : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isLastQuestion ? 'Continue' : 'Next',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
