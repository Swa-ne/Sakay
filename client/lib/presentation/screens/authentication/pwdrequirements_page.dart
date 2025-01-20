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
                'PWD',
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              const Text(
                'You are required',
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'To fulfill all the requirements needed for the security of the company and commuters.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),

              _buildRequirementItem(
                'Valid ID (Government Issued)',
                'assets/valid_id.png',
              ),
              _buildRequirementItem(
                'PWD Identification Card',
                'assets/pwd_id.png',
              ),
              _buildRequirementItem(
                'Medical Certificate (if applicable)',
                'assets/medical_certificate.png',
              ),
              _buildRequirementItem(
                'Proof of Address',
                'assets/proof_of_address.png',
              ),

              const SizedBox(height: 100.0),

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
                    backgroundColor: const Color(0xFF3A6C8D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
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

  Widget _buildRequirementItem(String text, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              text,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            flex: 1,
            child: Image.asset(
              imagePath,
              height: 60.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
