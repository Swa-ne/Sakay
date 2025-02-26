import 'package:flutter/material.dart';

class PerformanceReportPage extends StatefulWidget {
  const PerformanceReportPage({super.key});

  @override
  _PerformanceReportPageState createState() => _PerformanceReportPageState();
}

class _PerformanceReportPageState extends State<PerformanceReportPage> {
  final List<String> _vehicles = ['UNIT-24K', 'UNIT-69K', 'UNIT-88K'];
  String? _selectedVehicle;

  int _drivingRating = 0;
  int _serviceRating = 0;
  int _reliabilityRating = 0;

  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedVehicle = _vehicles.first;
  }

  void _onVehicleChanged(String? newValue) {
    setState(() {
      _selectedVehicle = newValue;
    });
  }

  void _setRating(int category, int rating) {
    setState(() {
      if (category == 1) _drivingRating = rating;
      if (category == 2) _serviceRating = rating;
      if (category == 3) _reliabilityRating = rating;
    });
  }

  void _submitReview() {
    // Handle review submission logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted successfully!')),
    );
  }

  Widget _buildRatingRow(String title, IconData icon, int category, int rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black, size: 24),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
                onPressed: () => _setRating(category, index + 1),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Performance Report', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.directions_bus, size: 24, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Vehicle Unit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedVehicle,
                          isExpanded: true,
                          items: _vehicles.map((vehicle) {
                            return DropdownMenuItem<String>(
                              value: vehicle,
                              child: Row(
                                children: [
                                  Image.asset('assets/bus.png', height: 50, width: 50),
                                  const SizedBox(width: 8),
                                  Text(vehicle),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: _onVehicleChanged,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A2FF),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/swane.png'),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ernesto Dimagiba ng Pagibig', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 4),
                        Text('09123456789', style: TextStyle(fontSize: 14, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Tell us about your experience with the driver",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildRatingRow("Driving", Icons.directions_car, 1, _drivingRating),
              _buildRatingRow("Service", Icons.handshake, 2, _serviceRating),
              _buildRatingRow("Reliability", Icons.verified, 3, _reliabilityRating),

              const SizedBox(height: 30),

              const Row(
                children: [
                  Icon(Icons.edit, color: Colors.black, size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Leave a review about the driver",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Write your review here...",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: const Text("Close", style: TextStyle(fontSize: 13, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _submitReview,
                    label: const Text("Send", style: TextStyle(fontSize: 13, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
