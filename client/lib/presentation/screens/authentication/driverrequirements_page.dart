import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/authentication/driver_upload.dart';

class DriverRequirementsPage extends StatelessWidget {
  const DriverRequirementsPage({super.key});

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
              const SizedBox(height: 10.0),
              _buildRequirementItem(
                'Driver’s License',
                'assets/requirement_pic.png',
                const [
                  'Proof of driving eligibility and competence for public roadways',
                  'Verifying the driver’s legal age, authorization, and skill to operate vehicles',
                ],
              ),
              _buildRequirementItem(
                'Vehicle Registration Documents',
                'assets/requirement_pic.png',
                const [
                  'Ownership or authorization to operate a vehicle for transport vehicles',
                  'Ensuring the vehicle meets regulatory standards for public use',
                ],
              ),
              _buildRequirementItem(
                'NBI or Police Clearance',
                'assets/requirement_pic.png',
                const [
                  'OEnsuring a Safe and Trustworthy Driving Record for Passenger Confidence',
                  'Validating a Clear Criminal Background for Public Transportation Safety',
                ],
              ),
              const SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DriverUploadPage(),
                      ),
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

  Widget _buildRequirementItem(String title, String imagePath,
      [List<String>? bullets]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                if (bullets != null) ...[
                  const SizedBox(height: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bullets
                        .expand((bullet) => [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '• ',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                    child: Text(
                                      bullet,
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                            ])
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          // Image
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                imagePath,
                height: 150.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
