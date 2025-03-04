import 'dart:io';

import 'package:sakay_app/data/models/announcement.dart';

abstract class AnnouncementRepo {
  Future<bool> saveAnnouncement(
    List<File> files,
    AnnouncementsModel announcement,
  );
  Future<List<AnnouncementsModel>> getAllAnnouncements(int page);
  Future<AnnouncementsModel> getAnnouncement(String announcement_id);
  Future<bool> editAnnouncement(
    List<File> files,
    List<String> existing_file_ids,
    AnnouncementsModel announcement,
  );
  Future<bool> deleteAnnouncement(String announcement_id);
}
