import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/report/report_bloc.dart';
import 'package:sakay_app/bloc/report/report_event.dart';
import 'package:sakay_app/bloc/report/report_state.dart';
import 'package:sakay_app/common/mixins/convertion.dart';
import 'package:sakay_app/data/models/report.dart';

class DisplayIncidentReportPage extends StatefulWidget {
  final ReportModel report;
  final VoidCallback updateReport;

  const DisplayIncidentReportPage({
    Key? key,
    required this.report,
    required this.updateReport,
  }) : super(key: key);

  @override
  State<DisplayIncidentReportPage> createState() =>
      _DisplayIncidentReportPageState();
}

class _DisplayIncidentReportPageState extends State<DisplayIncidentReportPage>
    with Convertion {
  late ReportBloc _reportBloc;
  bool is_open = false;

  @override
  void initState() {
    super.initState();
    _reportBloc = BlocProvider.of<ReportBloc>(context);
    setState(() {
      is_open = widget.report.is_open;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is ReportLoading) {
          // TODO: add lottie??
        } else if (state is ToggleReportSuccess) {
          setState(() {
            is_open = !is_open;
          });
          widget.updateReport();
          Navigator.pop(context);
        } else if (state is ToggleReportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is OnReceiveAdminToggleReportSuccess) {
          if (state.report.id == widget.report.id) {
            setState(() {
              is_open = !is_open;
            });
            widget.updateReport();
          }
        } else if (state is OnReceiveAdminToggleReportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              const Text(
                'Accident Report',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Icon(
                is_open ? Icons.hourglass_top : Icons.check_circle,
                color: is_open ? Colors.blue : Colors.green,
                size: 20,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.red.shade50,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.directions_bus_outlined,
                                  color: Colors.red, size: 32),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Bus: ${widget.report.bus?.bus_number} - ${widget.report.bus?.plate_number}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 8),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 8, vertical: 4),
                          //   decoration: BoxDecoration(
                          //     color: Colors.red,
                          //     borderRadius: BorderRadius.circular(3),
                          //   ),
                          //   child: Text(
                          //     'Severity: ${report.severity ?? "Unknown"}',
                          //     style: const TextStyle(
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 14,
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 16),
                          // Text(
                          //   report.message,
                          //   style: const TextStyle(
                          //     fontSize: 13,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.details, color: Colors.red, size: 25),
                              SizedBox(width: 5),
                              Text(
                                'Accident Details',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  widget.report.description,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Row(
                            children: [
                              Icon(Icons.info, color: Colors.red, size: 25),
                              SizedBox(width: 5),
                              Text(
                                'Incident Information',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _buildInfoRow(
                                      Icons.location_on,
                                      'Location',
                                      widget.report.place_of_incident ??
                                          'Unknown'),
                                  const SizedBox(height: 12),
                                  _buildInfoRow(
                                    Icons.calendar_today,
                                    'Date',
                                    formatToDate(widget.report.date_of_incident
                                        as String),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInfoRow(
                                    Icons.access_time,
                                    'Time',
                                    widget.report.time_of_incident as String,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInfoRow(Icons.person, 'Reported By',
                                      "${widget.report.reporter?.first_name} ${widget.report.reporter?.last_name}"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  icon: const Icon(Icons.read_more,
                      color: Colors.white, size: 25),
                  label: Text(is_open ? 'Close Report' : "Reopen Report"),
                  onPressed: () {
                    _reportBloc
                        .add(ToggleReportEvent(widget.report.id as String));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.red.shade300, size: 20),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
