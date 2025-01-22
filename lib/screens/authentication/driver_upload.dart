import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sakay_app/screens/authentication/submission_page.dart';

class DriverUploadPage extends StatefulWidget {
  const DriverUploadPage({super.key});

  @override
  _DriverUploadPageState createState() => _DriverUploadPageState();
}

class _DriverUploadPageState extends State<DriverUploadPage> {
  final Map<String, String> uploadedFiles = {
    'Front Side': '',
    'Back Side': '',
    'Vehicle Registration Documents': '',
    'NBI or Police Clearance': '',
  };

  Future<void> _uploadFile(String requirement) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String fileName = result.files.single.name;

      setState(() {
        uploadedFiles[requirement] = 'Uploaded: $fileName';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$requirement uploaded successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected.')),
      );
    }
  }

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
                'Driver',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5.0),
              const Text(
                'Submit the following requirements',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 50.0),

              const Text(
                'Driver\'s License',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),

              Row(
                children: [
                  Expanded(
                    child: _buildUploadSection('Front Side', fontSize: 14.0),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildUploadSection('Back Side', fontSize: 14.0),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              _buildUploadSection('Vehicle Registration Documents'),
              const SizedBox(height: 16.0),

              _buildUploadSection('NBI or Police Clearance'),
              const SizedBox(height: 20.0),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    bool allUploaded = uploadedFiles.values.every((file) => file.isNotEmpty);

                    if (allUploaded) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubmissionSuccessfulPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please upload all required documents before submitting.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 150.0),
                    backgroundColor: const Color(0xFF00A2FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
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

  Widget _buildUploadSection(String requirement, {double fontSize = 16.0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            requirement,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: (requirement == 'Front Side' || requirement == 'Back Side')
                  ? FontWeight.normal
                  : FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),

          GestureDetector(
            onTap: () {
              _uploadFile(requirement);
            },
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.upload_file,
                    color: Colors.grey,
                    size: 40.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  (uploadedFiles[requirement] ?? '').isEmpty ? 'Click to upload' : 'Re-upload',
                  style: const TextStyle(fontSize: 14.0, color: Color(0xFF3A6C8D)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
