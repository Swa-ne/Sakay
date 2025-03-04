import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/announcement.dart';

abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();

  @override
  List<Object> get props => [];
}

class ConnectAnnouncementRealtimeEvent extends AnnouncementEvent {}

class SaveAnnouncementEvent extends AnnouncementEvent {
  final List<File> files;
  final AnnouncementsModel announcement;

  const SaveAnnouncementEvent(this.files, this.announcement);

  @override
  List<Object> get props => [files, announcement];
}

class GetAllAnnouncementsEvent extends AnnouncementEvent {
  final int page;

  const GetAllAnnouncementsEvent(this.page);

  @override
  List<Object> get props => [page];
}

class GetAnnouncementEvent extends AnnouncementEvent {
  final String announcement_id;

  const GetAnnouncementEvent(this.announcement_id);

  @override
  List<Object> get props => [announcement_id];
}

class EditAnnouncementEvent extends AnnouncementEvent {
  final List<File> files;
  final List<String> existing_file_ids;
  final AnnouncementsModel announcement;

  const EditAnnouncementEvent(
    this.files,
    this.existing_file_ids,
    this.announcement,
  );

  @override
  List<Object> get props => [files, existing_file_ids, announcement];
}

class DeleteAnnouncementEvent extends AnnouncementEvent {
  final String announcement_id;

  const DeleteAnnouncementEvent(this.announcement_id);

  @override
  List<Object> get props => [announcement_id];
}

class OnReceiveAnnouncementEvent extends AnnouncementEvent {
  final AnnouncementsModel announcement;

  const OnReceiveAnnouncementEvent(this.announcement);

  @override
  List<Object> get props => [announcement];
}
