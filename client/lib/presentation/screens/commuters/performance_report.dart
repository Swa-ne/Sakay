import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/bus/bus_bloc.dart';
import 'package:sakay_app/bloc/bus/bus_event.dart';
import 'package:sakay_app/bloc/bus/bus_state.dart';
import 'package:sakay_app/bloc/report/report_bloc.dart';
import 'package:sakay_app/bloc/report/report_event.dart';
import 'package:sakay_app/bloc/report/report_state.dart';
import 'package:sakay_app/common/mixins/input_validation.dart';
import 'package:sakay_app/data/models/bus.dart';
import 'package:sakay_app/data/models/report.dart';

class PerformanceReportPage extends StatefulWidget {
  const PerformanceReportPage({super.key});

  @override
  _PerformanceReportPageState createState() => _PerformanceReportPageState();
}

class _PerformanceReportPageState extends State<PerformanceReportPage>
    with InputValidationMixin {
  late BusBloc _busBloc;
  late ReportBloc _reportBloc;

  final List<BusModel> _vehicles = [];
  BusModel? _selectedVehicle;

  int _drivingRating = 0;
  int _serviceRating = 0;
  int _reliabilityRating = 0;

  final TextEditingController _reviewController = TextEditingController();

  String? driver_name;
  String? profile;

  String? drivingError;
  String? serviceError;
  String? reliabilityError;
  String? reviewError;

  @override
  void initState() {
    super.initState();

    _busBloc = BlocProvider.of<BusBloc>(context);
    _reportBloc = BlocProvider.of<ReportBloc>(context);

    _busBloc.add(GetAllBusesEvent(DateTime.now()));
  }

  void _onVehicleChanged(BusModel? newValue) {
    setState(() {
      _selectedVehicle = newValue;
      driver_name =
          "${newValue!.today_driver?.first_name} ${newValue.today_driver?.last_name}";
      profile = newValue.today_driver?.profile;
    });
  }

  void _setRating(int category, int rating) {
    setState(() {
      if (category == 1) {
        _drivingRating = rating;
        drivingError = "";
      }
      if (category == 2) {
        _serviceRating = rating;
        serviceError = "";
      }
      if (category == 3) {
        _reliabilityRating = rating;
        reliabilityError = "";
      }
    });
  }

  void _submitReview() {
    bool has_error = false;
    String? validate_description =
        validateDescription(_reviewController.text.trim());
    if (validate_description != null) {
      setState(() {
        reviewError = validate_description;
      });
      has_error = true;
    }
    if (_serviceRating == 0) {
      setState(() {
        serviceError = "Please rate the service of the driver";
      });
      has_error = true;
    }
    if (_reliabilityRating == 0) {
      setState(() {
        reliabilityError = "Please rate the reliability of the driver";
      });
      has_error = true;
    }
    if (_drivingRating == 0) {
      setState(() {
        drivingError = "Please rate the driving of the driver";
      });
      has_error = true;
    }

    if (has_error) return;
    _reportBloc.add(
      PostPerformancetReportEvent(
        ReportModel(
          bus_id: _selectedVehicle?.id,
          type_of_report: "PERFORMANCE",
          description: _reviewController.text.trim(),
          driving_rate: _serviceRating,
          service_rate: _reliabilityRating,
          reliability_rate: _drivingRating,
          is_open: true,
          driver: _selectedVehicle?.today_driver,
        ),
      ),
    );
  }

  Widget _buildRatingRow(
      String title, IconData icon, int category, int rating, String? error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
        if (error != null) ...[
          const SizedBox(height: 6),
          Text(
            error,
            style: const TextStyle(
              color: Colors.red, // Error message in red
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BusBloc, BusState>(
      listener: (context, state) {
        if (state is GetAllBusesSuccess) {
          setState(() {
            _vehicles.addAll(state.buses);
            _selectedVehicle = _vehicles.first;
            driver_name =
                "${_selectedVehicle!.today_driver?.first_name} ${_selectedVehicle?.today_driver?.last_name}";
            profile = _selectedVehicle!.today_driver?.profile;
          });
        } else if (state is GetAllBusesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is SaveReportSuccess) {
            Navigator.pop(context);
          } else if (state is SaveReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Performance Report',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
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
                          Icon(Icons.directions_bus,
                              size: 24, color: Colors.black),
                          SizedBox(width: 8),
                          Text('Vehicle Unit',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
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
                            child: DropdownButton<BusModel>(
                              value: _selectedVehicle,
                              isExpanded: true,
                              items: _vehicles.map((vehicle) {
                                return DropdownMenuItem<BusModel>(
                                  value: vehicle,
                                  child: Row(
                                    children: [
                                      Image.asset('assets/bus.png',
                                          height: 50, width: 50),
                                      const SizedBox(width: 8),
                                      Text(
                                          "${vehicle.bus_number} - ${vehicle.plate_number}"),
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
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: profile ?? "",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(milliseconds: 300),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                  'assets/profile.jpg',
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(driver_name ?? "", // TODO: get deets
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
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
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildRatingRow("Driving", Icons.directions_car, 1,
                      _drivingRating, drivingError),
                  _buildRatingRow("Service", Icons.handshake, 2, _serviceRating,
                      serviceError),
                  _buildRatingRow("Reliability", Icons.verified, 3,
                      _reliabilityRating, reliabilityError),
                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Icon(Icons.edit, color: Colors.black, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "Leave a review about the driver",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        label: const Text("Close",
                            style:
                                TextStyle(fontSize: 13, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _submitReview,
                        label: const Text("Send",
                            style:
                                TextStyle(fontSize: 13, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
