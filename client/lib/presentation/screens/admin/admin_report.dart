import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/report/report_bloc.dart';
import 'package:sakay_app/bloc/report/report_event.dart';
import 'package:sakay_app/bloc/report/report_state.dart';
import 'package:sakay_app/common/widgets/report_tile.dart';
import 'package:sakay_app/data/models/report.dart';
import 'package:sakay_app/presentation/screens/admin/incident_report.dart';
import 'package:sakay_app/presentation/screens/admin/performance_report.dart';

class AdminReports extends StatefulWidget {
  final VoidCallback openDrawer;

  const AdminReports({super.key, required this.openDrawer});

  @override
  _AdminReportsState createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  late ReportBloc _reportBloc;
  final ScrollController _scrollController = ScrollController();

  String? selectedFilter;
  String? selectedStatusFilter;
  int currentPage = 1;
  bool isLoading = false;

  final List<ReportModel> reports = [];

  @override
  void initState() {
    super.initState();
    _reportBloc = BlocProvider.of<ReportBloc>(context);
    _reportBloc.add(GetAllReportsEvent(currentPage));
    _reportBloc.add(ConnectReportRealtimeEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 100 && !isLoading) {
      setState(() {
        isLoading = true;
        currentPage++;
      });
      _reportBloc.add(GetAllReportsEvent(currentPage));
    }
  }

  void _updateReport(ReportModel report) {
    setState(() {
      final index = reports.indexWhere((r) => r.id == report.id);
      if (index != -1) {
        reports[index] =
            reports[index].copyWith(is_open: !reports[index].is_open);
      }
    });
  }

  List<ReportModel> get filteredReports {
    List<ReportModel> filtered = reports;

    if (selectedFilter != null) {
      filtered = filtered
          .where((report) => report.type_of_report == selectedFilter)
          .toList();
    }

    if (selectedStatusFilter != null) {
      if (selectedStatusFilter == 'Open') {
        filtered = filtered.where((report) => report.is_open).toList();
      } else if (selectedStatusFilter == 'Closed') {
        filtered = filtered.where((report) => !report.is_open).toList();
      }
    }

    return filtered;
  }

  void _clearFilters() {
    setState(() {
      selectedFilter = null;
      selectedStatusFilter = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is ReportLoading) {
          // TODO: add lottie??
        } else if (state is GetAllReportsSuccess) {
          setState(() {
            reports.addAll(state.reports);
          });
        } else if (state is GetAllReportsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is OnReceiveAdminToggleReportSuccess) {
          _updateReport(state.report);
        } else if (state is OnReceiveAdminToggleReportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is OnReceiveAdminReportSuccess) {
          reports.insert(0, state.report);
        } else if (state is OnReceiveAdminReportError) {
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
          backgroundColor: const Color(0xFF00A3FF),
          leading: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: widget.openDrawer,
            ),
          ),
          title: const Text('Reports', style: TextStyle(color: Colors.white)),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              tooltip: 'Filter reports',
              onSelected: (String value) {
                setState(() {
                  if (value == 'All') {
                    selectedFilter = null;
                    selectedStatusFilter = null;
                  } else if (value == 'INCIDENT' || value == 'PERFORMANCE') {
                    if (selectedFilter == value) {
                      selectedFilter = null;
                    } else {
                      selectedFilter = value;
                    }
                  } else if (value == 'Open' || value == 'Closed') {
                    if (selectedStatusFilter == value) {
                      selectedStatusFilter = null;
                    } else {
                      selectedStatusFilter = value;
                    }
                  }
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'All',
                  child: ListTile(
                    leading: Icon(Icons.report, color: Colors.black, size: 25),
                    title: Text('All Reports'),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'INCIDENT',
                  child: ListTile(
                    leading: Icon(Icons.flag,
                        color: selectedFilter == 'INCIDENT'
                            ? Colors.blue
                            : Colors.red,
                        size: 25),
                    title: Text('Incident Reports',
                        style: TextStyle(
                            color: selectedFilter == 'INCIDENT'
                                ? Colors.blue
                                : Colors.black)),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'PERFORMANCE',
                  child: ListTile(
                    leading: Icon(Icons.person,
                        color: selectedFilter == 'PERFORMANCE'
                            ? Colors.blue
                            : Colors.orange,
                        size: 25),
                    title: Text('Performance Reports',
                        style: TextStyle(
                            color: selectedFilter == 'PERFORMANCE'
                                ? Colors.blue
                                : Colors.black)),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'Open',
                  child: ListTile(
                    leading: Icon(Icons.lock_open,
                        color: selectedStatusFilter == 'Open'
                            ? Colors.blue
                            : Colors.green,
                        size: 25),
                    title: Text('Open Reports',
                        style: TextStyle(
                            color: selectedStatusFilter == 'Open'
                                ? Colors.blue
                                : Colors.black)),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Closed',
                  child: ListTile(
                    leading: Icon(Icons.lock,
                        color: selectedStatusFilter == 'Closed'
                            ? Colors.blue
                            : Colors.red,
                        size: 25),
                    title: Text('Closed Reports',
                        style: TextStyle(
                            color: selectedStatusFilter == 'Closed'
                                ? Colors.blue
                                : Colors.black)),
                  ),
                ),
              ],
              color: Colors.white,
            ),
          ],
        ),
        body: Column(
          children: [
            if (selectedFilter != null || selectedStatusFilter != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    if (selectedFilter != null)
                      FilterChip(
                        label: Text(selectedFilter!),
                        onSelected: (bool value) {
                          setState(() {
                            selectedFilter = null;
                          });
                        },
                        backgroundColor: Colors.blue[100],
                        deleteIcon: const Icon(Icons.close, size: 16),
                      ),
                    if (selectedStatusFilter != null)
                      FilterChip(
                        label: Text(selectedStatusFilter!),
                        onSelected: (bool value) {
                          setState(() {
                            selectedStatusFilter = null;
                          });
                        },
                        backgroundColor: Colors.green[100],
                        deleteIcon: const Icon(Icons.close, size: 16),
                      ),
                    TextButton(
                      onPressed: _clearFilters,
                      child: const Text('Clear All Filters',
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: filteredReports.isEmpty
                  ? const Center(
                      child: Text('No reports found'),
                    )
                  : ListView.separated(
                      itemCount: filteredReports.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final report = filteredReports[index];
                        return ReportTile(
                          report: report,
                          onTap: () {
                            if (report.type_of_report == 'INCIDENT') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DisplayIncidentReportPage(
                                    report: report,
                                    updateReport: () => _updateReport(report),
                                  ),
                                ),
                              );
                            } else if (report.type_of_report == 'PERFORMANCE') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DisplayPerformanceReportPage(
                                    report: report,
                                    updateReport: () => _updateReport(report),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
