import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IncidentReportPage extends StatefulWidget {
  const IncidentReportPage({super.key});

  @override
  _IncidentReportPageState createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage> {
  final TextEditingController _reportedByController = TextEditingController();
  final TextEditingController _placeOfIncidentController = TextEditingController();
  final TextEditingController _briefDiscussionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime = TimeOfDay.now();

  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: Duration(
                    hours: _selectedTime!.hour,
                    minutes: _selectedTime!.minute,
                  ),
                  onTimerDurationChanged: (Duration duration) {
                    setState(() {
                      _selectedTime = TimeOfDay(
                        hour: duration.inHours,
                        minute: duration.inMinutes % 60,
                      );
                    });
                  },
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate ?? DateTime.now(),
                  onDateTimeChanged: (DateTime pickedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  },
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendIncidentReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Incident Report Sent")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Incident Report', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notifications, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'Details of Reporting the Incident',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField('Reported by:', _reportedByController, Icons.remove_red_eye),
            _buildTextField('Place of Incident:', _placeOfIncidentController, Icons.location_on),
            Row(
              children: [
                Expanded(
                  child: _buildDateTimeField(
                    'Time:',
                    _selectedTime != null ? _selectedTime!.format(context) : 'Select Time',
                    _showTimePicker,
                    Icons.access_time,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateTimeField(
                    'Date:',
                    _selectedDate != null
                        ? '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}'
                        : 'Select Date',
                    _showDatePicker,
                    Icons.calendar_today,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildParagraphField('Brief Discussion of Event:', _briefDiscussionController, Icons.edit),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Close', style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
                ElevatedButton(
                  onPressed: _sendIncidentReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A2FF),
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Send', style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildParagraphField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDateTimeField(String label, String value, VoidCallback onTap, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
