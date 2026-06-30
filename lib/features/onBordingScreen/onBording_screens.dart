import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'إدارة مشاريعك الذكية',
      'description':
          'نظم مشاريع البرمجة، التطوير، أو أعمالك الخاصة في مكان واحد وبكل سهولة.',
      'icon': Icons.assignment_outlined,
      'color': Colors.blueGrey,
    },
    {
      'title': 'تتبع المهام ديناميكياً',
      'description':
          'أضف المهام، حدد الأولويات، وشاهد حالة المشروع تتحدث تلقائياً مع كل خطوة تخطوها.',
      'icon': Icons.playlist_add_check_outlined,
      'color': Colors.teal,
    },
    {
      'title': 'دعم كامل بدون إنترنت',
      'description':
          'بياناتك محفوظة بأمان في الكاش المحلي (Hive)، وتتحول للـ Dark Mode تلقائياً لحماية عينيك.',
      'icon': Icons.cloud_off_outlined,
      'color': Colors.indigo,
    },
  ];

  void _onNextPage() async {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('show_onboarding', false);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = _onboardingData[index];
              return Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black87
                    : item['color'].withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Icon(
                              item['icon'],
                              size: 130,
                              color: item['color'],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 50),
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        item['description'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

       
          Positioned(
            bottom: 50,
            left: 30,
            child: Row(
              children: List.generate(
                _onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 8),
                  height: 8,
                  width: _currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? _onboardingData[_currentIndex]['color']
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 35,
            right: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _onboardingData[_currentIndex]['color'],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              ),
              onPressed: _onNextPage,
              child: Text(
                _currentIndex == _onboardingData.length - 1
                    ? 'ابدأ الآن'
                    : 'التالي',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
