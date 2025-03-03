import 'package:flutter/cupertino.dart';
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

class IncidentReportPage extends StatefulWidget {
  const IncidentReportPage({super.key});

  @override
  _IncidentReportPageState createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage>
    with InputValidationMixin {
  late BusBloc _busBloc;
  late ReportBloc _reportBloc;
  final TextEditingController _placeOfIncidentController =
      TextEditingController();
  final TextEditingController _briefDiscussionController =
      TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime = TimeOfDay.now();

  final List<BusModel> _vehicles = [];
  BusModel? _selectedVehicle;

  String? placeError;
  String? timeError;
  String? dateError;
  String? discussionError;

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
    });
  }

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
                onPressed: () {
                  if (_selectedTime == null) {
                    setState(() {
                      timeError = "This field is required";
                    });
                  } else {
                    setState(() {
                      timeError = null;
                    });
                  }
                  Navigator.pop(context);
                },
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
                onPressed: () {
                  if (_selectedDate == null) {
                    setState(() {
                      dateError = "This field is required";
                    });
                  } else {
                    setState(() {
                      dateError = null;
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text("Done"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendIncidentReport() {
    bool has_error = false;
    String? validate_place =
        validatePlaceOfIncident(_placeOfIncidentController.text.trim());
    if (validate_place != null) {
      setState(() {
        placeError = validate_place;
      });
      has_error = true;
    }
    String? validate_description =
        validateDescription(_briefDiscussionController.text.trim());
    if (validate_description != null) {
      setState(() {
        discussionError = validate_description;
      });
      has_error = true;
    }
    if (_selectedDate == null) {
      setState(() {
        dateError = "This field is required";
      });
      has_error = true;
    }
    if (_selectedTime == null) {
      setState(() {
        timeError = "This field is required";
      });
      has_error = true;
    }

    if (has_error) return;
    _reportBloc.add(
      PostIncidentReportEvent(
        ReportModel(
          bus_id: _selectedVehicle?.id,
          date_of_incident: _selectedDate.toString(),
          time_of_incident: _selectedTime.toString(),
          type_of_report: "INCIDENT",
          description: _briefDiscussionController.text.trim(),
          place_of_incident: _placeOfIncidentController.text.trim(),
          is_open: true,
        ),
      ),
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
            backgroundColor: Colors.white,
            title: const Text('Incident Report',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                _buildTextField(
                  'Place of Incident:',
                  _placeOfIncidentController,
                  placeError,
                  Icons.location_on,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateTimeField(
                        'Time:',
                        _selectedTime != null
                            ? _selectedTime!.format(context)
                            : 'Select Time',
                        timeError,
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
                        dateError,
                        _showDatePicker,
                        Icons.calendar_today,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildParagraphField(
                  'Brief Discussion of Event:',
                  _briefDiscussionController,
                  discussionError,
                  Icons.edit,
                ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        //TODO: add notif na successful ung pag report like ung sa SRM sa ssp
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Close',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                    ElevatedButton(
                      onPressed: _sendIncidentReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A2FF),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Send',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String? error,
    IconData icon,
  ) {
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
          onChanged: (value) {
            if (value.trim().isEmpty) {
              setState(() {
                placeError = "This field is required.";
              });
            } else {
              setState(() {
                placeError = null;
              });
            }
          },
          decoration: InputDecoration(
            filled: true,
            errorText: error,
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

  Widget _buildParagraphField(
    String label,
    TextEditingController controller,
    String? error,
    IconData icon,
  ) {
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
          onChanged: (value) {
            if (value.trim().isEmpty) {
              setState(() {
                discussionError = "This field is required.";
              });
            } else {
              setState(() {
                discussionError = null;
              });
            }
          },
          decoration: InputDecoration(
            filled: true,
            errorText: error,
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

  Widget _buildDateTimeField(String label, String value, String? error,
      VoidCallback onTap, IconData icon) {
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
        if (error != null) ...[
          const SizedBox(height: 5),
          Text(error, style: const TextStyle(color: Colors.red, fontSize: 14)),
        ],
      ],
    );
  }
}
