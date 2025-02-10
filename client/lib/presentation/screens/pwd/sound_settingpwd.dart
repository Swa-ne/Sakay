import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SoundSettingsScreen(),
    );
  }
}

class SoundSettingsScreen extends StatefulWidget {
  const SoundSettingsScreen({super.key});

  @override
  _SoundSettingsScreenState createState() => _SoundSettingsScreenState();
}

class _SoundSettingsScreenState extends State<SoundSettingsScreen> {
  double _ringVolume = 0.5;
  double _alarmVolume = 0.5;
  bool _vibrate = false;
  String _selectedSound = "Default";
  final TextEditingController _kmController = TextEditingController();

  final List<String> _soundOptions = ["Default", "Beep", "Chime", "Alert"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sound Settings"),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showSoundSettingsDialog(context);
          },
          child: const Text("Open Sound Settings"),
        ),
      ),
    );
  }

  void _showSoundSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              const Text("Input the allotted km for the reminder"),
              const SizedBox(height: 8),
              TextField(
                controller: _kmController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "KM",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sound"),
                  DropdownButton<String>(
                    value: _selectedSound,
                    items: _soundOptions.map((String sound) {
                      return DropdownMenuItem<String>(
                        value: sound,
                        child: Text(sound),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSound = newValue!;
                      });
                      Navigator.of(context).pop();
                      _showSoundSettingsDialog(context); // Refresh UI
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text("Ring Volume"),
              Slider(
                value: _ringVolume,
                onChanged: (value) {
                  setState(() {
                    _ringVolume = value;
                  });
                },
              ),
              const Text("Alarm Volume"),
              Slider(
                value: _alarmVolume,
                onChanged: (value) {
                  setState(() {
                    _alarmVolume = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Vibrate on each remind"),
                  Switch(
                    value: _vibrate,
                    onChanged: (value) {
                      setState(() {
                        _vibrate = value;
                      });
                      Navigator.of(context).pop();
                      _showSoundSettingsDialog(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
