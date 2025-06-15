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
  List<String>? _selectedFeatures;
  String? _selectedOption;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What best describes your home search?',
      'type': 'single_select',
      'key': 'user_type',
      'options': [
        'First-time home buyer',
        'Looking to rent',
        'Looking to buy',
        'Investor',
        'Just browsing',
      ],
    },
    {
      'question': 'What are your must-have features?',
      'type': 'multi_select',
      'key': 'must_have_features',
      'options': [
        'Pet-friendly',
        'Parking space',
        'Balcony/Patio',
        'In-unit laundry',
        'Fully furnished',
        'Swimming pool',
        'Gym',
        'Security',
      ],
    },
    {
      'question': 'When are you planning to move?',
      'type': 'single_select',
      'key': 'timeline',
      'options': [
        'Immediately',
        'Within 1 month',
        '1-3 months',
        '3-6 months',
        'Just exploring options',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedFeatures = [];
  }

  Future<void> _savePreferences() async {
    // Initialize an empty map to store all preferences
    final Map<String, dynamic> preferences = {};
    
    // Store the user type (from first question)
    if (_questions.isNotEmpty) {
      preferences['user_type'] = _selectedOption ?? 'Not specified';
    }
    
    // Store must-have features (from second question)
    if (_selectedFeatures != null && _selectedFeatures!.isNotEmpty) {
      preferences['must_have_features'] = _selectedFeatures!.join(',');
    } else {
      preferences['must_have_features'] = 'None selected';
    }
    
    // Store timeline (from third question)
    if (_questions.length > 2) {
      preferences['timeline'] = _selectedOption ?? 'No timeline specified';
    }
    
    debugPrint('Saving preferences: $preferences');
    
    try {
      await OnboardingService.saveUserPreferences(preferences);
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.home);
      }
    } catch (e) {
      debugPrint('Error saving preferences: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.home);
      }
    }
  }

  void _handleOptionTap(dynamic option) {
    final currentQuestion = _questions[_currentQuestionIndex];
    
    if (currentQuestion['type'] == 'multi_select') {
      setState(() {
        if (_selectedFeatures!.contains(option)) {
          _selectedFeatures!.remove(option);
        } else {
          _selectedFeatures!.add(option);
        }
      });
    } else {
      setState(() {
        _selectedOption = option;
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
                      ? _selectedFeatures!.contains(option)
                      : _selectedOption == option;

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
                        ? _selectedFeatures!.isNotEmpty
                        : _selectedOption != null)),
                width: double.infinity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: () {
                      if ((currentQuestion['type'] == 'multi_select' &&
                              _selectedFeatures!.isNotEmpty) ||
                          (currentQuestion['type'] == 'single_select' &&
                              _selectedOption != null)) {
                        _nextQuestion();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLastQuestion ? 'Let\'s Get Started' : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
