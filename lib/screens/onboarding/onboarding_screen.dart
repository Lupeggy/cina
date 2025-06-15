import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cina/core/theme/app_theme.dart';
import 'package:cina/core/theme/app_colors.dart';
import 'package:cina/services/onboarding_service.dart';
import 'package:cina/core/routes/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  final Future<void> Function() onComplete;
  
  const OnboardingScreen({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Explore Iconic Movie Locations',
      description: 'Discover and visit the most famous filming locations from your favorite movies and TV shows around the world.',
      icon: Icons.movie_outlined,
    ),
    OnboardingPage(
      title: 'Create Your Movie Journey',
      description: 'Save your favorite film locations and plan your ultimate movie-themed travel itinerary.',
      icon: Icons.travel_explore,
    ),
    OnboardingPage(
      title: 'Immerse in Film History',
    description: 'Learn behind-the-scenes stories and fun facts about how these locations were used in cinema.',
    icon: Icons.theaters_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onComplete() async {
    print('Onboarding completion triggered');
    try {
      // Call the completion callback first
      // The callback will handle marking onboarding as complete and navigation
      if (mounted) {
        print('Calling onComplete callback');
        await widget.onComplete();
        print('onComplete callback completed');
      }
    } catch (e) {
      if (!mounted) return;
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  @override
  void initState() {
    super.initState();
    print('OnboardingScreen initialized');
  }

  @override
  Widget build(BuildContext context) {
    print('Building OnboardingScreen');
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFF5F7FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _onComplete,
                  child: Text(
                    'Skip',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) => _pages[index],
                ),
              ),
              
              // Page Indicator
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingXl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == index ? 24.0 : 8.0,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Next/Get Started Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingLg,
                  vertical: AppTheme.paddingLg,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _onComplete();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 120,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingXxl),
          
          // Title
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          
          // Description
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

