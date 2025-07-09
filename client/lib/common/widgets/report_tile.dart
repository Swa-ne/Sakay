import 'package:flutter/material.dart';
import 'package:sakay_app/common/mixins/convertion.dart';
import 'package:sakay_app/data/models/report.dart';

class ReportTile extends StatefulWidget {
  final ReportModel report;
  final VoidCallback onTap;

  const ReportTile({
    super.key,
    required this.report,
    required this.onTap,
  });

  @override
  State<ReportTile> createState() => _ReportTileState();
}

class _ReportTileState extends State<ReportTile> with Convertion {
  late Stream<String> _timeAgoStream;

  @override
  void initState() {
    super.initState();
    _timeAgoStream = Stream.periodic(
      const Duration(minutes: 1),
      (_) => timeAgo(widget.report.createdAt.toString()),
    ).asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getTypeColor(widget.report.type_of_report),
        child: Icon(
          _getTypeIcon(widget.report.type_of_report),
          color: Colors.white,
        ),
      ),
      title: Text(
        widget.report.type_of_report == "PERFORMANCE"
            ? "${widget.report.driver?.first_name} ${widget.report.driver?.last_name}"
            : 'Bus: ${widget.report.bus?.bus_number} - ${widget.report.bus?.plate_number}',
        style: TextStyle(
            fontWeight:
                widget.report.is_open ? FontWeight.normal : FontWeight.bold,
            fontSize: 15),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(widget.report.description, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor(widget.report.type_of_report)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.report.type_of_report,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getTypeColor(widget.report.type_of_report),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StreamBuilder<String>(
                stream: _timeAgoStream,
                initialData: timeAgo(widget.report.createdAt.toString()),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: widget.onTap,
      trailing: Icon(
        widget.report.is_open ? Icons.hourglass_top : Icons.check_circle,
        color: widget.report.is_open ? Colors.blue : Colors.green,
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'INCIDENT':
        return Colors.red;
      case 'PERFORMANCE':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Incident':
        return Icons.warning;
      case 'Performance':
        return Icons.person;
      default:
        return Icons.report;
    }
  }
}
