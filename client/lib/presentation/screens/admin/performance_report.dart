import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/report/report_bloc.dart';
import 'package:sakay_app/bloc/report/report_event.dart';
import 'package:sakay_app/bloc/report/report_state.dart';
import 'package:sakay_app/common/mixins/convertion.dart';
import 'package:sakay_app/data/models/report.dart';

class DisplayPerformanceReportPage extends StatefulWidget {
  final ReportModel report;
  final VoidCallback updateReport;

  const DisplayPerformanceReportPage({
    Key? key,
    required this.report,
    required this.updateReport,
  }) : super(key: key);

  @override
  State<DisplayPerformanceReportPage> createState() =>
      _DisplayPerformanceReportPageState();
}

class _DisplayPerformanceReportPageState
    extends State<DisplayPerformanceReportPage> with Convertion {
  late ReportBloc _reportBloc;
  bool is_open = false;
  var metrics;
  @override
  void initState() {
    super.initState();
    _reportBloc = BlocProvider.of<ReportBloc>(context);
    metrics = {
      "Driving Rating": "${widget.report.driving_rate}/5",
      "Service Rating": "${widget.report.service_rate}/5",
      "Reliability": "${widget.report.reliability_rate}/5",
    };
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
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              const Text(
                'Driver Performance Report',
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: Colors.orange.shade50,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person,
                            color: Colors.orange, size: 32),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.report.driver?.first_name} ${widget.report.driver?.last_name}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Bus: ${widget.report.bus?.bus_number} - ${widget.report.bus?.plate_number}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 8),
                    // Container(
                    //   padding:
                    //       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    //   decoration: BoxDecoration(
                    //     color: _getTrendColor(report.trend),
                    //     borderRadius: BorderRadius.circular(3),
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(
                    //         _getTrendIcon(report.trend),
                    //         color: Colors.white,
                    //         size: 16,
                    //       ),
                    //       const SizedBox(width: 4),
                    //       Text(
                    //         'Performance: ${report.trend ?? "Stable"}',
                    //         style: const TextStyle(
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
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
                        Icon(Icons.summarize, color: Colors.orange, size: 25),
                        SizedBox(width: 5),
                        Text(
                          'Report Feedback',
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
                        Icon(Icons.show_chart, color: Colors.orange, size: 25),
                        SizedBox(width: 5),
                        Text(
                          'Performance Metrics',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: metrics.length,
                      itemBuilder: (context, index) {
                        String key = metrics.keys.elementAt(index);
                        String value = metrics[key]!;
                        return Card(
                          color: Colors.orange.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  key,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.grey, size: 25),
                        const SizedBox(width: 8),
                        Text(
                          'Report Generated: ${timeAgo(widget.report.createdAt.toString())}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        icon: const Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 25,
                        ),
                        label: const Text('Contact Driver'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Opening messaging interface...'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 13),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        icon: const Icon(
                          Icons.read_more,
                          color: Colors.white,
                          size: 25,
                        ),
                        label: Text(is_open ? 'Close Report' : "Reopen Report"),
                        onPressed: () {
                          _reportBloc.add(
                              ToggleReportEvent(widget.report.id as String));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
