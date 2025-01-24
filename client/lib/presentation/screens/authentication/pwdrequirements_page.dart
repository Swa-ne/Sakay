import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/authentication/pwd_upload.dart';

class PWDRequirementsPage extends StatelessWidget {
  const PWDRequirementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You are required',
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'To fulfill all the requirements needed for the security of the company and commuters.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),

              _buildRequirementItem(
                'Government-Issued PWD ID',
                [
                  'Serves as official identification for Persons with Disabilities (PWD).',
                  'Must be authorized and validated by the government.',
                ],
                'assets/requirement_pic.png',
              ),
              _buildRequirementItem(
                'Medical Certificate or Report',
                [
                  'Provides proof of a certified medical condition.',
                  'Should be signed by a licensed healthcare professional.',
                ],
                'assets/requirement_pic.png',
              ),
              _buildRequirementItem(
                'Disability Certification from Relevant Agencies',
                [
                  'Confirms disability status through authorized agencies.',
                  'Required for validation of eligibility and benefits.',
                ],
                'assets/requirement_pic.png',
              ),

              const SizedBox(height: 60.0),

              // Continue Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PWDUploadPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 150.0,
                    ),
                    backgroundColor: const Color(0xFF00A2FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Requirement Items with Updated Subtitles
  Widget _buildRequirementItem(
      String title, List<String> bullets, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5.0),
                ...bullets.map(
                  (bullet) => Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ', // Bullet point
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                        ),
                        Expanded(
                          child: Text(
                            bullet,
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                imagePath,
                height: 120.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
