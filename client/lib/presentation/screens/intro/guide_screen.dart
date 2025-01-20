import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/authentication/login_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // PageView with slides
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(), // Smooth bouncing effect
              children: [
                _buildSlide(
                  'assets/guidescreen1.png', // Image for slide 1
                  'INTRODUCING', // Header for slide 1
                  'Learn about our app. Here is some detailed description of how the app works.',
                  'Next',
                  () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  null, // No back button on slide 1
                ),
                _buildSlide(
                  'assets/guidescreen2.png', // Image for slide 2
                  'KEY FEATURES', // Header for slide 2
                  'This is the second slide. Learn about the features and how to use them.',
                  'Next',
                  () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
                _buildSlide(
                  'assets/guidescreen3.png', // Image for slide 3
                  'BENEFITS', // Header for slide 3
                  'This is the third slide. Ready to start using the app? Let\'s get you going!',
                  'Continue',
                  () {
                    // Navigate to the login screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(String imagePath, String header, String description,
      String buttonText, VoidCallback onPressed, VoidCallback? onBackPressed) {
    return Stack(
      children: [
        // Image at the top
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 250.0, // Adjust height as necessary
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40.0), // Space between image and text
            // Header text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                header,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
                height: 20.0), // Space between header and description
            // Description text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 60.0),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: const ExpandingDotsEffect(
                  dotWidth: 12.0,
                  dotHeight: 12.0,
                  activeDotColor: Color(0xFF3A6C8D),
                  dotColor: Colors.grey,
                  spacing: 20.0,
                  expansionFactor: 4.0,
                  paintStyle: PaintingStyle.fill,
                ),
              ),
            ),
            // Button (Next/Continue)
            const SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A6C8D),
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 130.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              child: Text(buttonText,
                  style: const TextStyle(fontSize: 15.0, color: Colors.white)),
            ),
          ],
        ),

        if (onBackPressed != null)
          Positioned(
            left: 10.0,
            top: 10.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed,
              color: Colors.black,
            ),
          ),
      ],
    );
  }
}
