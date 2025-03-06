import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/announcement.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();

  @override
  List<Object> get props => [];
}

class ConnectingAnnouncementRealtimeSocket extends AnnouncementState {}

class ConnectedAnnouncementRealtimeSocket extends AnnouncementState {}

class AnnouncementLoading extends AnnouncementState {}

class AnnouncementReady extends AnnouncementState {}

class SaveAnnouncementSuccess extends AnnouncementState {}

class SaveAnnouncementError extends AnnouncementState {
  final String error;

  const SaveAnnouncementError(this.error);

  @override
  List<Object> get props => [error];
}

class EditAnnouncementSuccess extends AnnouncementState {
  final AnnouncementsModel announcement;

  const EditAnnouncementSuccess(this.announcement);

  @override
  List<Object> get props => [announcement];
}

class EditAnnouncementError extends AnnouncementState {
  final String error;

  const EditAnnouncementError(this.error);

  @override
  List<Object> get props => [error];
}

class OnReceiveAnnouncementSuccess extends AnnouncementState {
  final AnnouncementsModel announcement;

  const OnReceiveAnnouncementSuccess(this.announcement);

  @override
  List<Object> get props => [announcement];
}

class OnReceiveAnnouncementError extends AnnouncementState {
  final String error;

  const OnReceiveAnnouncementError(this.error);

  @override
  List<Object> get props => [error];
}

class OnReceiveUpdateAnnouncementSuccess extends AnnouncementState {
  final AnnouncementsModel announcement;

  const OnReceiveUpdateAnnouncementSuccess(this.announcement);

  @override
  List<Object> get props => [announcement];
}

class OnReceiveUpdateAnnouncementError extends AnnouncementState {
  final String error;

  const OnReceiveUpdateAnnouncementError(this.error);

  @override
  List<Object> get props => [error];
}

class GetAnnouncementSuccess extends AnnouncementState {
  final AnnouncementsModel announcement;

  const GetAnnouncementSuccess(this.announcement);

  @override
  List<Object> get props => [announcement];
}

class GetAnnouncementError extends AnnouncementState {
  final String error;

  const GetAnnouncementError(this.error);

  @override
  List<Object> get props => [error];
}

class GetAllAnnouncementsSuccess extends AnnouncementState {
  final List<AnnouncementsModel> announcements;

  const GetAllAnnouncementsSuccess(this.announcements);

  @override
  List<Object> get props => [announcements];
}

class GetAllAnnouncementsError extends AnnouncementState {
  final String error;

  const GetAllAnnouncementsError(this.error);

  @override
  List<Object> get props => [error];
}

class DeleteAnnouncementSuccess extends AnnouncementState {}

class DeleteAnnouncementError extends AnnouncementState {
  final String error;

  const DeleteAnnouncementError(this.error);

  @override
  List<Object> get props => [error];
}

class ConnectionAnnouncementRealtimeError extends AnnouncementState {
  final String error;

  const ConnectionAnnouncementRealtimeError(this.error);

  @override
  List<Object> get props => [error];
}
