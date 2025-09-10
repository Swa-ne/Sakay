import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lottie/lottie.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/animations/introducing.json',
      'title': 'INTRODUCING',
      'description':
          'Sakay is a real-time bus tracking system designed to improve public transportation along the Lingayen-Dagupan route. Using advanced GPS technology, it provides accurate updates on vehicle locations, estimated arrival times, and proximity alerts for a more convenient travel experience.',
      'buttonText': 'Next'
    },
    {
      'image': 'assets/animations/keyfeatures.json',
      'title': 'KEY FEATURES',
      'description':
          'Sakay reduces waiting times, enhances commuting efficiency, and provides drivers with route optimization insights. It also promotes sustainable transportation by encouraging public transport use and reducing congestion.',
      'buttonText': 'Next'
    },
    {
      'image': 'assets/animations/benefits.json',
      'title': 'BENEFITS',
      'description':
          'Sakay offers real-time vehicle tracking, accurate arrival estimates, and proximity alerts, all presented through an easy-to-navigate, user-friendly interface.',
      'buttonText': 'Continue'
    },
  ];

  void _nextSlide() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if background is white to apply dark mode for text
    final bool isDarkMode = true; // Since background is white, apply dark mode
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color subtitleColor = isDarkMode ? Colors.white70 : Colors.grey;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  color: isDarkMode ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        _slides[index]['image']!,
                        height: 230.0,
                        alignment: Alignment.center,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 40.0),
                      Text(
                        _slides[index]['title']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        _slides[index]['description']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          SmoothPageIndicator(
            controller: _pageController,
            count: _slides.length,
            effect: ExpandingDotsEffect(
              dotWidth: 10.0,
              dotHeight: 10.0,
              activeDotColor: const Color(0xFF00A2FF),
              dotColor: Colors.grey,
              spacing: 10.0,
              expansionFactor: 4.0,
              paintStyle: PaintingStyle.fill,
            ),
          ),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _nextSlide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A2FF),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  _slides[_currentIndex]['buttonText']!,
                  style: const TextStyle(fontSize: 13.0, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
