import 'package:flutter/material.dart';
import 'package:sakay_app/data/models/announcement.dart';
import 'package:sakay_app/presentation/screens/common/announcement_main.dart';

// TODO: add refresh callback
class AnnouncementsScreen extends StatefulWidget {
  final List<AnnouncementsModel> announcements;
  final ScrollController scrollAnnouncementController;
  final bool isLoadingAnnouncement;

  const AnnouncementsScreen({
    super.key,
    required this.announcements,
    required this.scrollAnnouncementController,
    required this.isLoadingAnnouncement,
  });

  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Announcements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: widget.announcements.isEmpty
                    ? const Center(
                        child: Text("No announcements yet"),
                      )
                    : ListView.builder(
                        itemCount: widget.announcements.length,
                        controller: widget.scrollAnnouncementController,
                        itemBuilder: (context, index) {
                          final announcement = widget.announcements[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AnnouncementDetailScreen(
                                    announcement: announcement,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors
                                    .transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.campaign,
                                      color: Color(0xFF00A3FF)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          announcement.headline,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          announcement.content,
                                          style: const TextStyle(
                                              color: Color(0xFF888888)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.more_horiz,
                                      color: Colors.black),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
